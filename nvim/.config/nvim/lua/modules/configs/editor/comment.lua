-- 注释插件配置：gcc 切换行注释，gbc 切换块注释
return function()
	require("modules.utils").load_plugin("Comment", {
		ignore = "^$",
	})
end
