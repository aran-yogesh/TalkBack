#!/usr/bin/env python3
"""
Unit tests for cursor_code_monitor.py
Covers: yaml_scalar, to_yaml, error counting, response type logic, file I/O
"""

import os
import sys
import tempfile
import unittest
from unittest.mock import patch

# Add parent directory to path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from cursor_code_monitor import (
    MAX_PROMPT_SIZE_BYTES,
    ROAST_ERROR_THRESHOLD,
    CodeExecutionMonitor,
    to_yaml,
    validate_message_fields,
    yaml_scalar,
)


# ---------------------------------------------------------------------------
# yaml_scalar tests
# ---------------------------------------------------------------------------

class TestYamlScalar(unittest.TestCase):

    def test_bool_true(self):
        self.assertEqual(yaml_scalar(True), "true")

    def test_bool_false(self):
        self.assertEqual(yaml_scalar(False), "false")

    def test_none(self):
        self.assertEqual(yaml_scalar(None), "null")

    def test_integer(self):
        self.assertEqual(yaml_scalar(42), "42")

    def test_negative_integer(self):
        self.assertEqual(yaml_scalar(-7), "-7")

    def test_float(self):
        self.assertEqual(yaml_scalar(3.14), "3.14")

    def test_zero(self):
        self.assertEqual(yaml_scalar(0), "0")

    def test_string_simple(self):
        self.assertEqual(yaml_scalar("hello"), '"hello"')

    def test_string_with_spaces(self):
        self.assertEqual(yaml_scalar("hello world"), '"hello world"')

    def test_string_with_special_chars(self):
        result = yaml_scalar('say "hi"')
        self.assertIn("say", result)

    def test_string_empty(self):
        self.assertEqual(yaml_scalar(""), '""')

    def test_non_string_non_primitive(self):
        # Lists/objects fall through to json.dumps(str(value))
        result = yaml_scalar([1, 2, 3])
        self.assertIsInstance(result, str)


# ---------------------------------------------------------------------------
# to_yaml tests
# ---------------------------------------------------------------------------

class TestToYaml(unittest.TestCase):

    def test_empty_dict(self):
        self.assertEqual(to_yaml({}), "{}\n")

    def test_empty_list(self):
        self.assertEqual(to_yaml([]), "[]\n")

    def test_flat_dict(self):
        result = to_yaml({"key": "value"})
        self.assertIn("key:", result)
        self.assertIn('"value"', result)

    def test_flat_dict_int_value(self):
        result = to_yaml({"count": 5})
        self.assertIn("count: 5", result)

    def test_flat_dict_bool_value(self):
        result = to_yaml({"success": True})
        self.assertIn("success: true", result)

    def test_flat_dict_none_value(self):
        result = to_yaml({"result": None})
        self.assertIn("result: null", result)

    def test_nested_dict(self):
        data = {"outer": {"inner": "val"}}
        result = to_yaml(data)
        self.assertIn("outer:", result)
        self.assertIn("inner:", result)

    def test_empty_nested_dict(self):
        result = to_yaml({"empty": {}})
        self.assertIn("empty: {}", result)

    def test_list_of_strings(self):
        result = to_yaml(["a", "b", "c"])
        self.assertIn('- "a"', result)
        self.assertIn('- "b"', result)

    def test_list_of_ints(self):
        result = to_yaml([1, 2, 3])
        self.assertIn("- 1", result)
        self.assertIn("- 2", result)

    def test_dict_with_empty_list(self):
        result = to_yaml({"items": []})
        self.assertIn("items: []", result)

    def test_dict_with_list_value(self):
        result = to_yaml({"errors": ["e1", "e2"]})
        self.assertIn("errors:", result)
        self.assertIn('- "e1"', result)

    def test_nested_list_of_dicts(self):
        result = to_yaml([{"a": 1}, {"b": 2}])
        self.assertIn("-", result)

    def test_indentation_increases_for_nested(self):
        result = to_yaml({"outer": {"inner": 1}}, indent=0)
        lines = result.strip().split("\n")
        # inner key should be indented more than outer key
        outer_line = next(x for x in lines if "outer" in x)
        inner_line = next(x for x in lines if "inner" in x)
        self.assertGreater(len(inner_line) - len(inner_line.lstrip()),
                           len(outer_line) - len(outer_line.lstrip()))

    def test_scalar_fallthrough(self):
        result = to_yaml("just a string")
        self.assertIn("just a string", result)

    def test_multikey_dict_preserves_all_keys(self):
        data = {"a": 1, "b": 2, "c": 3}
        result = to_yaml(data)
        for key in ["a:", "b:", "c:"]:
            self.assertIn(key, result)


# ---------------------------------------------------------------------------
# validate_message_fields tests
# ---------------------------------------------------------------------------

class TestValidateMessageFields(unittest.TestCase):

    def test_valid_message_passes_through(self):
        msg = {"prompt": "hello", "type": "roast", "error_count": 3}
        result = validate_message_fields(msg)
        self.assertEqual(result["prompt"], "hello")

    def test_invalid_type_raises(self):
        msg = {"type": "invalid_type"}
        with self.assertRaises(ValueError):
            validate_message_fields(msg)

    def test_negative_error_count_raises(self):
        msg = {"error_count": -1}
        with self.assertRaises(ValueError):
            validate_message_fields(msg)

    def test_oversized_prompt_is_truncated(self):
        big_prompt = "x" * (MAX_PROMPT_SIZE_BYTES + 1000)
        msg = {"prompt": big_prompt, "type": "roast", "error_count": 1}
        result = validate_message_fields(msg)
        self.assertLessEqual(
            len(result["prompt"].encode("utf-8")), MAX_PROMPT_SIZE_BYTES
        )

    def test_prompt_at_limit_is_not_truncated(self):
        exact_prompt = "x" * MAX_PROMPT_SIZE_BYTES
        msg = {"prompt": exact_prompt}
        result = validate_message_fields(msg)
        self.assertEqual(result["prompt"], exact_prompt)

    def test_truncation_preserves_valid_utf8(self):
        # Build a prompt with multibyte chars that would split at the boundary
        emoji_prompt = "\U0001f600" * (MAX_PROMPT_SIZE_BYTES // 4 + 100)
        msg = {"prompt": emoji_prompt}
        result = validate_message_fields(msg)
        # Should be valid utf-8 and within limit
        encoded = result["prompt"].encode("utf-8")
        self.assertLessEqual(len(encoded), MAX_PROMPT_SIZE_BYTES)

    def test_none_prompt_passes(self):
        msg = {"prompt": None, "type": "roast"}
        result = validate_message_fields(msg)
        self.assertIsNone(result["prompt"])

    def test_all_valid_types_accepted(self):
        for t in ("roast", "minor_sass", "sassy_success"):
            msg = {"type": t}
            result = validate_message_fields(msg)
            self.assertEqual(result["type"], t)

    def test_zero_error_count_accepted(self):
        msg = {"error_count": 0}
        result = validate_message_fields(msg)
        self.assertEqual(result["error_count"], 0)


class TestConstants(unittest.TestCase):

    def test_max_prompt_size_is_5kb(self):
        self.assertEqual(MAX_PROMPT_SIZE_BYTES, 5 * 1024)

    def test_roast_threshold_is_2(self):
        self.assertEqual(ROAST_ERROR_THRESHOLD, 2)


# ---------------------------------------------------------------------------
# CodeExecutionMonitor.count_errors_in_output tests
# ---------------------------------------------------------------------------

class TestCountErrors(unittest.TestCase):

    def setUp(self):
        self.monitor = CodeExecutionMonitor()

    def test_no_errors_clean_output(self):
        self.assertEqual(self.monitor.count_errors_in_output("All tests passed!"), 0)

    def test_single_error_keyword(self):
        count = self.monitor.count_errors_in_output("error: undefined variable")
        self.assertGreater(count, 0)

    def test_traceback(self):
        output = "Traceback (most recent call last):\n  File 'x.py', line 1"
        count = self.monitor.count_errors_in_output(output)
        self.assertGreater(count, 0)

    def test_syntax_error(self):
        count = self.monitor.count_errors_in_output("SyntaxError: invalid syntax")
        self.assertGreater(count, 0)

    def test_type_error(self):
        count = self.monitor.count_errors_in_output("TypeError: unsupported operand type")
        self.assertGreater(count, 0)

    def test_value_error(self):
        count = self.monitor.count_errors_in_output("ValueError: invalid literal")
        self.assertGreater(count, 0)

    def test_import_error(self):
        count = self.monitor.count_errors_in_output("ImportError: No module named 'foo'")
        self.assertGreater(count, 0)

    def test_module_not_found(self):
        count = self.monitor.count_errors_in_output("ModuleNotFoundError: No module named 'bar'")
        self.assertGreater(count, 0)

    def test_attribute_error(self):
        count = self.monitor.count_errors_in_output("AttributeError: object has no attribute 'x'")
        self.assertGreater(count, 0)

    def test_compilation_failed(self):
        count = self.monitor.count_errors_in_output("compilation failed: 3 issues")
        self.assertGreater(count, 0)

    def test_build_failed(self):
        count = self.monitor.count_errors_in_output("build failed with exit code 1")
        self.assertGreater(count, 0)

    def test_exception_keyword(self):
        count = self.monitor.count_errors_in_output("Caught exception in handler")
        self.assertGreater(count, 0)

    def test_multiple_errors_accumulate(self):
        output = "error: foo\nTraceback\nSyntaxError: bar"
        count = self.monitor.count_errors_in_output(output)
        self.assertGreater(count, 2)

    def test_case_insensitive_error(self):
        # "ERROR:" should match
        count = self.monitor.count_errors_in_output("ERROR: critical failure")
        self.assertGreater(count, 0)

    def test_empty_string(self):
        self.assertEqual(self.monitor.count_errors_in_output(""), 0)

    def test_test_failed(self):
        count = self.monitor.count_errors_in_output("test failed: 2 of 5 tests")
        self.assertGreater(count, 0)


# ---------------------------------------------------------------------------
# CodeExecutionMonitor.send_to_talkback — response type selection
# ---------------------------------------------------------------------------

class TestSendToTalkback(unittest.TestCase):

    def setUp(self):
        self.tmp = tempfile.NamedTemporaryFile(suffix=".yaml", delete=False)
        self.tmp.close()
        self.monitor = CodeExecutionMonitor(talkback_message_file=self.tmp.name)

    def tearDown(self):
        os.unlink(self.tmp.name)

    def _read_message(self):
        with open(self.tmp.name) as f:
            return f.read()

    def test_two_plus_errors_writes_roast_type(self):
        self.monitor.send_to_talkback("some output", 2, False)
        content = self._read_message()
        self.assertIn("roast", content)

    def test_many_errors_writes_roast_type(self):
        self.monitor.send_to_talkback("boom", 10, False)
        content = self._read_message()
        self.assertIn("roast", content)

    def test_one_error_writes_minor_sass_type(self):
        self.monitor.send_to_talkback("one bad line", 1, False)
        content = self._read_message()
        self.assertIn("minor_sass", content)

    def test_zero_errors_writes_sassy_success_type(self):
        self.monitor.send_to_talkback("all good", 0, True)
        content = self._read_message()
        self.assertIn("sassy_success", content)

    def test_file_contains_timestamp(self):
        self.monitor.send_to_talkback("output", 0, True)
        content = self._read_message()
        # timestamp key should be present
        self.assertIn("timestamp:", content)

    def test_file_contains_error_count(self):
        self.monitor.send_to_talkback("output", 3, False)
        content = self._read_message()
        self.assertIn("error_count:", content)

    def test_file_contains_success_field(self):
        self.monitor.send_to_talkback("output", 0, True)
        content = self._read_message()
        self.assertIn("success:", content)

    def test_file_contains_prompt(self):
        self.monitor.send_to_talkback("output", 0, True)
        content = self._read_message()
        self.assertIn("prompt:", content)

    def test_roast_prompt_mentions_error_count(self):
        self.monitor.send_to_talkback("crash", 5, False)
        content = self._read_message()
        self.assertIn("5", content)

    def test_write_error_handled_gracefully(self):
        monitor = CodeExecutionMonitor("/nonexistent_dir/msg.yaml")
        # Should not raise; just print error
        try:
            monitor.send_to_talkback("output", 0, True)
        except Exception:
            self.fail("send_to_talkback raised an exception on write failure")


# ---------------------------------------------------------------------------
# CodeExecutionMonitor.monitor_terminal_command tests
# ---------------------------------------------------------------------------

class TestMonitorTerminalCommand(unittest.TestCase):

    def setUp(self):
        self.tmp = tempfile.NamedTemporaryFile(suffix=".yaml", delete=False)
        self.tmp.close()
        self.monitor = CodeExecutionMonitor(talkback_message_file=self.tmp.name)

    def tearDown(self):
        os.unlink(self.tmp.name)

    def _read_message(self):
        with open(self.tmp.name) as f:
            return f.read()

    def test_successful_command_writes_sassy_success(self):
        self.monitor.monitor_terminal_command("echo 'hello world'")
        content = self._read_message()
        self.assertIn("sassy_success", content)

    def test_command_with_error_output(self):
        # python -c with a syntax error should produce error output
        self.monitor.monitor_terminal_command("python3 -c 'raise ValueError(\"test error\")'")
        content = self._read_message()
        # Should detect the error pattern
        self.assertTrue(
            "roast" in content or "minor_sass" in content,
            f"Expected roast or minor_sass, got: {content[:200]}"
        )

    def test_timeout_sends_message(self):
        monitor = CodeExecutionMonitor(talkback_message_file=self.tmp.name)
        with patch("cursor_code_monitor.subprocess.run", side_effect=__import__("subprocess").TimeoutExpired("cmd", 30)):
            monitor.monitor_terminal_command("sleep 100")
        content = self._read_message()
        # Should still write something (minor_sass for timeout)
        self.assertTrue(len(content) > 0)

    def test_exception_in_run_sends_message(self):
        with patch("cursor_code_monitor.subprocess.run", side_effect=OSError("no such program")):
            self.monitor.monitor_terminal_command("nonexistent_command_xyz")
        content = self._read_message()
        self.assertTrue(len(content) > 0)


# ---------------------------------------------------------------------------
# CodeExecutionMonitor initialisation
# ---------------------------------------------------------------------------

class TestMonitorInit(unittest.TestCase):

    def test_default_message_file(self):
        m = CodeExecutionMonitor()
        self.assertEqual(m.talkback_message_file, "/tmp/talkback_message.yaml")

    def test_custom_message_file(self):
        m = CodeExecutionMonitor("/tmp/custom.yaml")
        self.assertEqual(m.talkback_message_file, "/tmp/custom.yaml")

    def test_initial_error_count_zero(self):
        m = CodeExecutionMonitor()
        self.assertEqual(m.last_error_count, 0)

    def test_monitoring_starts_true(self):
        m = CodeExecutionMonitor()
        self.assertTrue(m.monitoring)


if __name__ == "__main__":
    unittest.main()
