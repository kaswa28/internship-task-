document.addEventListener("DOMContentLoaded", function () {
    const loginForm = document.getElementById("login-form");
    const registerForm = document.getElementById("register-form");
    const todoApp = document.getElementById("todo-app");
    const showRegister = document.getElementById("show-register");
    const showLogin = document.getElementById("show-login");
    const loginBtn = document.getElementById("login-btn");
    const registerBtn = document.getElementById("register-btn");
    const logoutBtn = document.getElementById("logout-btn");

    const taskInput = document.getElementById("task-input");
    const taskDueDate = document.getElementById("task-due-date");
    const taskCategory = document.getElementById("task-category");
    const taskPriority = document.getElementById("task-priority");
    const taskList = document.getElementById("task-list");
    const addTaskBtn = document.getElementById("add-task-btn");
    const taskCount = document.getElementById("task-count");
    const clearAllBtn = document.getElementById("clear-all-btn");
    const progressBar = document.getElementById("progress-bar");
    const downloadTasksBtn = document.getElementById("download-tasks");

    let tasks = JSON.parse(localStorage.getItem("tasks")) || [];

    // ✅ Save Tasks to Local Storage
    function saveTasks() {
        localStorage.setItem("tasks", JSON.stringify(tasks));
    }

    // ✅ Add Task Function
    addTaskBtn.addEventListener("click", function () {
        const taskText = taskInput.value.trim();
        const dueDate = taskDueDate.value;
        const category = taskCategory.value;
        const priority = taskPriority.value;

        if (taskText === "") return alert("Please enter a task!");

        const task = {
            id: Date.now(),
            text: taskText,
            dueDate: dueDate,
            category: category,
            priority: priority,
            completed: false,
            recurring: "None" // Recurring feature
        };

        tasks.push(task);
        saveTasks();
        updateTaskList();
        taskInput.value = "";
    });

    // ✅ Update Task List
    function updateTaskList() {
        taskList.innerHTML = "";
        let completedCount = 0;

        tasks.forEach(task => {
            const li = document.createElement("li");
            li.classList.add("task-item");
            li.draggable = true; // Drag & Drop Enabled
            if (task.completed) li.classList.add("completed");

            li.innerHTML = `
                <span>${task.text} (${task.category} - ${task.priority})</span>
                <small>Due: ${task.dueDate}</small>
                <div>
                    <button onclick="toggleComplete(${task.id})">✔</button>
                    <button onclick="deleteTask(${task.id})">❌</button>
                </div>
            `;

            taskList.appendChild(li);
            if (task.completed) completedCount++;
        });

        taskCount.textContent = `${tasks.length} Tasks | ${completedCount} Completed`;
        updateProgressBar();
    }

    // ✅ Toggle Task Completion
    window.toggleComplete = function (id) {
        tasks = tasks.map(task => {
            if (task.id === id) task.completed = !task.completed;
            return task;
        });
        saveTasks();
        updateTaskList();
    };

    // ✅ Delete Task
    window.deleteTask = function (id) {
        tasks = tasks.filter(task => task.id !== id);
        saveTasks();
        updateTaskList();
    };

    // ✅ Clear Completed Tasks
    clearAllBtn.addEventListener("click", function () {
        tasks = tasks.filter(task => !task.completed);
        saveTasks();
        updateTaskList();
    });

    // ✅ Progress Bar Update
    function updateProgressBar() {
        const completed = tasks.filter(task => task.completed).length;
        const total = tasks.length;
        const percentage = total === 0 ? 0 : (completed / total) * 100;
        progressBar.style.width = percentage + "%";
    }

    // ✅ Download Tasks as CSV
    downloadTasksBtn.addEventListener("click", function () {
        let csvContent = "Task,Category,Priority,Due Date,Completed\n";
        tasks.forEach(task => {
            csvContent += `${task.text},${task.category},${task.priority},${task.dueDate},${task.completed}\n`;
        });

        const blob = new Blob([csvContent], { type: "text/csv" });
        const link = document.createElement("a");
        link.href = URL.createObjectURL(blob);
        link.download = "tasks.csv";
        link.click();
    });

    // ✅ Task Notifications (Reminders)
    function checkTaskReminders() {
        const today = new Date().toISOString().split("T")[0];
        tasks.forEach(task => {
            if (task.dueDate === today && !task.completed) {
                alert(`Reminder: Task "${task.text}" is due today!`);
            }
        });
    }
    setInterval(checkTaskReminders, 60000); // Check every minute

    // ✅ Drag & Drop Functionality
    let draggedItem = null;

    taskList.addEventListener("dragstart", function (e) {
        draggedItem = e.target;
        setTimeout(() => e.target.style.display = "none", 0);
    });

    taskList.addEventListener("dragover", function (e) {
        e.preventDefault();
        const afterElement = getDragAfterElement(taskList, e.clientY);
        if (afterElement == null) {
            taskList.appendChild(draggedItem);
        } else {
            taskList.insertBefore(draggedItem, afterElement);
        }
    });

    taskList.addEventListener("dragend", function () {
        draggedItem.style.display = "block";
        draggedItem = null;
    });

    function getDragAfterElement(container, y) {
        const draggableElements = [...container.querySelectorAll(".task-item:not(.dragging)")];
        return draggableElements.reduce(
            (closest, child) => {
                const box = child.getBoundingClientRect();
                const offset = y - box.top - box.height / 2;
                if (offset < 0 && offset > closest.offset) {
                    return { offset: offset, element: child };
                } else {
                    return closest;
                }
            },
            { offset: Number.NEGATIVE_INFINITY }
        ).element;
    }

    // ✅ Load Tasks on Start
    updateTaskList();
});
