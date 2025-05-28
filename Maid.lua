--!strict

-- Adaptação por Cow.

export type MaidTask = () -> () | Instance | RBXScriptConnection | Maid | thread

export type MaidClass = {
	__index: MaidClass,

	new: () -> Maid,

	Add: <E>(self: Maid, task: MaidTask & E) -> E,
	Clear: (self: Maid) -> (),
	Remove: (self: Maid, task: MaidTask) -> boolean
}

export type Maid = typeof(setmetatable({} :: {
	tasks: {MaidTask}
}, {} :: MaidClass))

local function Drop(maidTask: any)
	local t = typeof(maidTask)

	if t == "function" then
		task.spawn(maidTask)
	elseif t == "thread" then
		pcall(task.cancel, maidTask)
	else
		maidTask[t == "RBXScriptConnection" and "Disconnect" or "Destroy"](maidTask)
	end
end

local Maid = {} :: MaidClass
Maid.__index = Maid

function Maid.new(): Maid
	return setmetatable({tasks = {}}, Maid)
end

function Maid.Add<E>(self: Maid, task: MaidTask & E): E
	self.tasks[#self.tasks + 1] = task :: MaidTask
	return task :: E
end

function Maid.Clear(self: Maid)
	for i = #self.tasks, 1, -1 do
		if self.tasks[i] then
			Drop(table.remove(self.tasks, i))
		end
	end

	table.clear(self.tasks)
end

function Maid.Remove(self: Maid, task: MaidTask)
	local i = table.find(self.tasks, task)
	local exists = i ~= nil

	if exists then
		Drop(table.remove(self.tasks, i))
	end

	return exists
end

return Maid
