---- nvim-dap: A plugin for harnesing Debug Application Protocol (DAP). ----
local function dap_config()
	local dap = require("dap")
	local dapui = require("dapui")

	---- Configure the DAP plugin for debugging: ----
	dapui.setup({
		---- Define a layout for the debugging UI. ----
		layouts = {
			-- Configure a UI component group positioned on the right. --
			{
				-- Define the UI components to use in the group. --
				-- NOTE: sizes are relative (% of overall size). --
				elements = {
					--  A window indicating all variables & their scopes. --
					{ id = "scopes", size = 0.34 },
					-- A window indicating all breakpoints. --
					{ id = "breakpoints", size = 0.33 },
					-- A window indicating the call stack upto a breakpoint. --
					{ id = "stacks", size = 0.33 },
				},
				size = 40,
				position = "right",
			},
			-- Configure a UI component group positioned to the bottom. --
			{
				-- Define the UI components to use in the group. --
				elements = {
					-- Add a Read Eval Print Loop debug window (REPL). --
					{ id = "repl", size = 1.0 },
					-- I do not tend to need/use a console. --
					--{ id = "console", size = 0.55 },
				},
				size = 15,
				position = "bottom",
			},
		},
	})

	---- Configure language-specific adapters. ----
	---- Python DAP adapter configuration: ----
	-- Define the DAP Python adapter source to be used for debugging Python. --
	dap.adapters.python = {
		type = "executable",
		-- NOTE: this has to be kept as Python3, no aliasing to Python. --
		command = "python3",
		-- NOTE: debugpy package must be installed in your environment. --
		args = { "-m", "debugpy.adapter" },
	}

	-- Configure the Python DAP adapter. --
	dap.configurations.python = {
		{
			type = "python",
			request = "launch",
			name = "Launch Python File",
			program = "${file}",
			-- Set the pythonpath dynamically. --
			pythonPath = function()
				-- Check for any activated virtual environments first. --
				local venv = os.getenv("VIRTUAL_ENV")
				-- If a virtual environment was active, get the right path. --
				if venv then
					return venv .. "/bin/python"
				end

				-- Else, fallback to the system installed Python. --
				return "/Library/Frameworks/Python.framework/Versions/3.13/bin/python3"
			end,
		},
	}

	---- Another language configuration would go here... ----
	-- ... --

	---- Auto-open and close UI when debugging starts/stops: ----
	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open()
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close()
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close()
	end

	---- Define keymaps for debugging operations ----
	-- Define a keymap to toggle a debugging breakpoint. --
	vim.keymap.set("n", "<leader>db", function()
		dap.toggle_breakpoint()
	end, {
		desc = "Debug: Toggle breakpoint",
	})
	-- Define a keymap to begin or continue debugging. --
	vim.keymap.set("n", "<leader>dc", function()
		dap.continue()
	end, {
		desc = "Debug: Start/Continue",
	})
	-- Define a keymap to step over during debugging. --
	vim.keymap.set("n", "<leader>dn", function()
		dap.step_over()
	end, {
		desc = "Debug: Step over",
	})
	-- Define a keymap to step into during debugging. --
	vim.keymap.set("n", "<leader>di", function()
		dap.step_into()
	end, {
		desc = "Debug: Step into",
	})
	-- Define a keymap to step out of during debugging. --
	vim.keymap.set("n", "<leader>do", function()
		dap.step_out()
	end, {
		desc = "Debug: Step out",
	})
	-- Define a keymap to stop/quit debugging. --
	vim.keymap.set("n", "<leader>dx", function()
		dap.terminate()
	end, {
		desc = "Debug: Terminate session",
	})

	---- Define visuals to display in the sign column for debug lines. ----
	-- Define visuals for breakpoint lines. --
	vim.fn.sign_define(
		"DapBreakpoint",
		{ text = "🔴", texthl = "ErrorMsg", linehl = "", numhl = "" }
	)
	-- Define visuals when debugging paused on a breakpoint line. --
	vim.fn.sign_define("DapStopped", {
		text = "🟡",
		texthl = "WarningMsg",
		linehl = "CursorLine",
		numhl = "",
	})
end

---- Define the Lua table to pass to Lazy for plugin management ----
return {
	-- Define the plugin installation source. --
	"mfussenegger/nvim-dap",

	-- Define the events that will trigger the plugin to load (when called). --
	keys = {
		{
			"<leader>db",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Debug: Toggle breakpoint",
		},
		{
			"<leader>dc",
			function()
				require("dap").continue()
			end,
			desc = "Debug: Start/Continue",
		},
		{
			"<leader>dn",
			function()
				require("dap").step_over()
			end,
			desc = "Debug: Step over",
		},
		{
			"<leader>di",
			function()
				require("dap").step_into()
			end,
			desc = "Debug: Step into",
		},
		{
			"<leader>do",
			function()
				require("dap").step_out()
			end,
			desc = "Debug: Step out",
		},
		{
			"<leader>dx",
			function()
				require("dap").terminate()
			end,
			desc = "Debug: Terminate session",
		},
	},

	-- Define the plugin dependencies. --
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"mfussenegger/nvim-dap-python",
		"nvim-neotest/nvim-nio",
	},
	-- Define the plugin-specific configuration
	config = dap_config,
}
