#!/usr/bin/env python3
"""
Unit tests for shared YAML utilities (yaml_scalar + to_yaml).
These functions are duplicated across monitor, mcp_server and test_mcp_connection,
so we verify consistent behaviour here using the test_mcp_connection copy.
"""

import json
import os
import sys
import unittest

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from test_mcp_connection import to_yaml, yaml_scalar


class TestSharedYamlScalar(unittest.TestCase):
    """Edge-case and boundary tests for yaml_scalar."""

    # --- bool ---
    def test_true_is_lowercase(self):
        self.assertEqual(yaml_scalar(True), "true")

    def test_false_is_lowercase(self):
        self.assertEqual(yaml_scalar(False), "false")

    # --- None ---
    def test_none_is_null(self):
        self.assertEqual(yaml_scalar(None), "null")

    # --- numbers ---
    def test_zero_int(self):
        self.assertEqual(yaml_scalar(0), "0")

    def test_positive_int(self):
        self.assertEqual(yaml_scalar(1_000_000), "1000000")

    def test_negative_int(self):
        self.assertEqual(yaml_scalar(-42), "-42")

    def test_float_precision(self):
        self.assertEqual(yaml_scalar(0.1), "0.1")

    def test_large_float(self):
        result = yaml_scalar(1e10)
        self.assertIsInstance(result, str)

    # --- strings ---
    def test_plain_string_is_json_quoted(self):
        self.assertEqual(yaml_scalar("hi"), '"hi"')

    def test_string_with_newline(self):
        result = yaml_scalar("line1\nline2")
        # json.dumps escapes \n
        self.assertIn("\\n", result)

    def test_string_with_tab(self):
        result = yaml_scalar("col1\tcol2")
        self.assertIn("\\t", result)

    def test_string_with_unicode(self):
        result = yaml_scalar("日本語")
        self.assertIn("日本語", result)

    def test_string_with_backslash(self):
        result = yaml_scalar("path\\to\\file")
        self.assertIn("\\\\", result)

    def test_string_with_double_quotes(self):
        result = yaml_scalar('say "hello"')
        # json.dumps wraps with outer quotes and escapes inner
        self.assertTrue(result.startswith('"'))

    # --- fallback ---
    def test_list_falls_back_to_string(self):
        result = yaml_scalar([1, 2, 3])
        self.assertIsInstance(result, str)

    def test_dict_falls_back_to_string(self):
        result = yaml_scalar({"k": "v"})
        self.assertIsInstance(result, str)


class TestSharedToYaml(unittest.TestCase):
    """Comprehensive structural tests for to_yaml."""

    # --- empty containers ---
    def test_empty_dict(self):
        self.assertEqual(to_yaml({}), "{}\n")

    def test_empty_list(self):
        self.assertEqual(to_yaml([]), "[]\n")

    # --- scalar passthrough ---
    def test_int_scalar(self):
        result = to_yaml(42)
        self.assertIn("42", result)

    def test_float_scalar(self):
        result = to_yaml(3.14)
        self.assertIn("3.14", result)

    def test_none_scalar(self):
        result = to_yaml(None)
        self.assertIn("null", result)

    def test_bool_true_scalar(self):
        result = to_yaml(True)
        self.assertIn("true", result)

    # --- flat dict ---
    def test_dict_string_value(self):
        result = to_yaml({"msg": "hello"})
        self.assertIn("msg:", result)
        self.assertIn('"hello"', result)

    def test_dict_int_value(self):
        result = to_yaml({"n": 5})
        self.assertIn("n: 5", result)

    def test_dict_bool_value(self):
        result = to_yaml({"flag": True})
        self.assertIn("flag: true", result)

    def test_dict_none_value(self):
        result = to_yaml({"x": None})
        self.assertIn("x: null", result)

    def test_dict_empty_nested_dict(self):
        result = to_yaml({"sub": {}})
        self.assertIn("sub: {}", result)

    def test_dict_empty_nested_list(self):
        result = to_yaml({"items": []})
        self.assertIn("items: []", result)

    # --- nested dict ---
    def test_nested_dict_two_levels(self):
        result = to_yaml({"a": {"b": 1}})
        self.assertIn("a:", result)
        self.assertIn("b:", result)
        self.assertIn("1", result)

    def test_nested_dict_three_levels(self):
        result = to_yaml({"l1": {"l2": {"l3": "deep"}}})
        self.assertIn("l1:", result)
        self.assertIn("l2:", result)
        self.assertIn("l3:", result)

    # --- lists ---
    def test_list_of_ints(self):
        result = to_yaml([1, 2, 3])
        self.assertIn("- 1", result)
        self.assertIn("- 2", result)
        self.assertIn("- 3", result)

    def test_list_of_strings(self):
        result = to_yaml(["a", "b"])
        self.assertIn('- "a"', result)
        self.assertIn('- "b"', result)

    def test_list_of_dicts_has_dash(self):
        result = to_yaml([{"k": 1}])
        self.assertIn("-", result)

    def test_dict_with_populated_list(self):
        result = to_yaml({"errors": ["e1", "e2"]})
        self.assertIn("errors:", result)
        self.assertIn('- "e1"', result)

    # --- indentation ---
    def test_indentation_zero(self):
        result = to_yaml({"k": "v"}, indent=0)
        self.assertTrue(result.startswith("k:"))

    def test_indentation_two(self):
        result = to_yaml({"k": "v"}, indent=2)
        self.assertTrue(result.startswith("  k:"))

    def test_indentation_four(self):
        result = to_yaml({"k": "v"}, indent=4)
        self.assertTrue(result.startswith("    k:"))

    def test_nested_child_more_indented_than_parent(self):
        result = to_yaml({"outer": {"inner": 1}})
        lines = result.strip().split("\n")
        outer_indent = len(lines[0]) - len(lines[0].lstrip())
        inner_line = next(l for l in lines if "inner" in l)
        inner_indent = len(inner_line) - len(inner_line.lstrip())
        self.assertGreater(inner_indent, outer_indent)

    # --- output format ---
    def test_output_ends_with_newline(self):
        self.assertTrue(to_yaml({"k": 1}).endswith("\n"))

    def test_list_output_ends_with_newline(self):
        self.assertTrue(to_yaml([1, 2]).endswith("\n"))

    # --- realistic TalkBack message ---
    def test_talkback_message_roundtrip_keys(self):
        msg = {
            "prompt": "ROAST ME!",
            "type": "roast",
            "timestamp": 1710000000.0,
            "error_count": 3,
            "success": False,
        }
        result = to_yaml(msg)
        for key in ["prompt:", "type:", "timestamp:", "error_count:", "success:"]:
            self.assertIn(key, result)

    def test_talkback_message_success_true(self):
        msg = {"success": True, "error_count": 0}
        result = to_yaml(msg)
        self.assertIn("success: true", result)
        self.assertIn("error_count: 0", result)


class TestYamlConsistencyAcrossModules(unittest.TestCase):
    """Verify all three module copies of yaml_scalar/to_yaml give the same output."""

    def setUp(self):
        import cursor_code_monitor as mon
        import cursor_mcp_server as srv
        import test_mcp_connection as con
        self.modules = [mon, srv, con]

    def test_yaml_scalar_bool_consistent(self):
        results = [m.yaml_scalar(True) for m in self.modules]
        self.assertEqual(len(set(results)), 1, f"Inconsistent: {results}")

    def test_yaml_scalar_none_consistent(self):
        results = [m.yaml_scalar(None) for m in self.modules]
        self.assertEqual(len(set(results)), 1)

    def test_yaml_scalar_int_consistent(self):
        results = [m.yaml_scalar(42) for m in self.modules]
        self.assertEqual(len(set(results)), 1)

    def test_yaml_scalar_string_consistent(self):
        results = [m.yaml_scalar("test") for m in self.modules]
        self.assertEqual(len(set(results)), 1)

    def test_to_yaml_flat_dict_consistent(self):
        data = {"key": "value", "n": 1, "ok": True}
        results = [m.to_yaml(data) for m in self.modules]
        self.assertEqual(len(set(results)), 1, f"Inconsistent:\n{results}")

    def test_to_yaml_empty_dict_consistent(self):
        results = [m.to_yaml({}) for m in self.modules]
        self.assertEqual(len(set(results)), 1)

    def test_to_yaml_list_consistent(self):
        results = [m.to_yaml([1, 2, 3]) for m in self.modules]
        self.assertEqual(len(set(results)), 1)


if __name__ == "__main__":
    unittest.main()
