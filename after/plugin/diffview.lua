local status_ok, git_diff = pcall(require, "diffview")

if not status_ok then
	return
end

git_diff.setup()
