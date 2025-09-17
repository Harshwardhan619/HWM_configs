return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    local harpoon = require("harpoon")

    -- REQUIRED
    harpoon:setup({
      settings = {
        save_on_toggle = true, -- Save when UI is toggled
        sync_on_ui_close = false,
      },
    })
    -- REQUIRED

    -- Basic telescope configuration
    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers")
        .new({}, {
          prompt_title = "Harpoon",
          finder = require("telescope.finders").new_table({
            results = file_paths,
          }),
          previewer = conf.file_previewer({}),
          sorter = conf.generic_sorter({}),
        })
        :find()
    end

    -- Add file to harpoon list
    vim.keymap.set("n", "<leader>ha", function()
      harpoon:list():add()
    end, { desc = "Harpoon add file" })

    -- Remove current file from harpoon list
    vim.keymap.set("n", "<leader>hr", function()
      harpoon:list():remove()
    end, { desc = "Harpoon remove file" })

    -- Toggle harpoon quick menu (original UI)
    vim.keymap.set("n", "<C-e>", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon toggle quick menu" })

    -- Toggle harpoon quick menu (original UI)
    vim.keymap.set("n", "<leader>hq", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon toggle quick menu" })

    -- Toggle harpoon with telescope (alternative UI)
    vim.keymap.set("n", "<leader>he", function()
      toggle_telescope(harpoon:list())
    end, { desc = "Harpoon telescope menu" })

    -- Select specific files from harpoon list
    vim.keymap.set("n", "<leader>1", function()
      harpoon:list():select(1)
    end, { desc = "Harpoon select file 1" })
    vim.keymap.set("n", "<leader>2", function()
      harpoon:list():select(2)
    end, { desc = "Harpoon select file 2" })
    vim.keymap.set("n", "<leader>3", function()
      harpoon:list():select(3)
    end, { desc = "Harpoon select file 3" })
    vim.keymap.set("n", "<leader>4", function()
      harpoon:list():select(4)
    end, { desc = "Harpoon select file 4" })
    vim.keymap.set("n", "<leader>5", function()
      harpoon:list():select(5)
    end, { desc = "Harpoon select file 5" })

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set("n", "<C-p>", function()
      harpoon:list():prev()
    end, { desc = "Harpoon previous file" })
    vim.keymap.set("n", "<C-n>", function()
      harpoon:list():next()
    end, { desc = "Harpoon next file" })
  end,
}
