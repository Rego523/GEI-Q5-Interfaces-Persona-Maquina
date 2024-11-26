// Function to load tasks from localStorage and display them in index.html
function loadTasks() {
    updateTaskDisplay();
    updateActiveTasksDisplay();
}

// Function to add a task to localStorage
function addTask(task) {
    let tasks = JSON.parse(sessionStorage.getItem('tasks')) || [];
    tasks.push(task);
    sessionStorage.setItem('tasks', JSON.stringify(tasks));
}

// Function to update the display of tasks
function updateTaskDisplay(filter = 'Show All') {
    const tasks = JSON.parse(sessionStorage.getItem('tasks')) || [];
    const tableBody = document.querySelector('.table tbody');
    tableBody.innerHTML = '';

    console.log(tasks);
    tasks.forEach(task => {
        if (filter === 'Show All' || 
            (filter === 'Show Active' && !task.completed) ||
            (filter === 'Show Completed' && task.completed)) {

            const row = document.createElement('tr');
            row.innerHTML = `
                <td>
                    <input type="checkbox" class="checkbox" id="checkbox-${task.id}" aria-checked="${task.completed ? 'true' : 'false'}" onchange="toggleTaskCompletion(this)" ${task.completed ? 'checked' : ''}>
                </td>
                <td tabindex="0" class="table_text">${task.name}</td>
                <td class="actions_section">
                    <button class="action_button" onclick="editTaskDescription('${task.id}')">
                        <img src="./assets/edit_description.svg" alt="Edit task description" class="dropdown_icon_list">
                    </button>
                    <button class="action_button" onclick="deleteTask('${task.id}')">
                        <img src="./assets/delete_task.svg" alt="Delete task" class="dropdown_icon_list">
                    </button>
                </td>
            `;

            const descriptionRow = document.createElement('tr');
            descriptionRow.classList.add('description-row');
            descriptionRow.innerHTML = `<td tabindex="0" colspan="3">${task.description}</td>`;

            tableBody.appendChild(row);
            tableBody.appendChild(descriptionRow);
        }
    });

    // Add click event to each row
    document.querySelectorAll('.table tbody tr').forEach(row => {
        row.addEventListener('click', function() {
            const isClicked = row.classList.contains('clicked');
            document.querySelectorAll('.table tbody tr').forEach(r => r.classList.remove('clicked'));

            if (!isClicked) {
                row.classList.add('clicked');
            }

            // Find the next description row
            const nextRow = this.nextElementSibling;
            // Toggle show/hide
           if (nextRow && nextRow.classList.contains('description-row')) {
            nextRow.style.display = isClicked ? 'none' : 'table-row';
        }
        });
    });

    updateActiveTasksDisplay();
}

function countActiveTasks() {
    const tasks = JSON.parse(sessionStorage.getItem('tasks')) || [];
    const activeTasksCount = tasks.filter(task => !task.completed).length;
    return activeTasksCount;
}

function updateActiveTasksDisplay() {
    const activeTasksCount = countActiveTasks();
    document.getElementById('activeTasksCount').textContent = `Active Tasks: ${activeTasksCount}`;
}

function generateUniqueId() {
    const date = new Date();
    const timestamp = date.getTime();
    const randomNum = Math.floor(Math.random() * 1000);
    return 'task-' + timestamp + '-' + randomNum;
}

function toggleTaskCompletion(checkbox) {
    const taskId = checkbox.id.replace('checkbox-', '');
    let tasks = JSON.parse(sessionStorage.getItem('tasks')) || [];
    const taskIndex = tasks.findIndex(t => t.id === taskId);

    if (taskIndex !== -1) {
        tasks[taskIndex].completed = checkbox.checked;
        sessionStorage.setItem('tasks', JSON.stringify(tasks));
    } else {
        console.error('Task not found:', taskId);
    }
    updateActiveTasksDisplay();
}

function deleteTask(taskId) {
    let tasks = JSON.parse(sessionStorage.getItem('tasks')) || [];
    // Filter tasks to remove the selected one
    tasks = tasks.filter(task => task.id !== taskId);

    // Save the updated array in localStorage
    sessionStorage.setItem('tasks', JSON.stringify(tasks));

    // Update the task display
    updateTaskDisplay();
    updateActiveTasksDisplay();
}

function editTaskDescription(taskId) {
    let tasks = JSON.parse(sessionStorage.getItem('tasks')) || [];
    const taskIndex = tasks.findIndex(task => task.id === taskId);

    if (taskIndex !== -1) {
        const newDescription = prompt("Edit task description:", tasks[taskIndex].description);

        if (newDescription !== null) {
            tasks[taskIndex].description = newDescription;

            sessionStorage.setItem('tasks', JSON.stringify(tasks));

            updateTaskDisplay();
        }
    } else {
        console.error('Task not found:', taskId);
    }
}

function completeAllTasks() {
    let tasks = JSON.parse(sessionStorage.getItem('tasks')) || [];
    tasks.forEach(task => task.completed = true);
    sessionStorage.setItem('tasks', JSON.stringify(tasks));
    updateTaskDisplay();
}

// Event to handle form submission in form.html
if (document.querySelector('.form')) {
    document.querySelector('.form').addEventListener('submit', function(e) {
        e.preventDefault();

        const taskName = document.getElementById('taskName').value;
        const taskDescription = document.getElementById('taskDescription').value;
        const dueDate = document.getElementById('dueDate').value;
        const taskId = generateUniqueId();

        if (!taskName || !taskDescription || !dueDate) {
            alert("Please fill in all fields to create a task.");
            return;
        }

        const task = {
            id: taskId,
            name: taskName,
            description: taskDescription,
            dueDate: dueDate,
            completed: false
        };

        addTask(task);
        window.location.href = 'index.html';
        this.reset();
    });
}

// Event for task filter
document.getElementById('taskFilter').addEventListener('change', function() {
    updateTaskDisplay(this.value);
});

// Mark all tasks as completed
document.getElementById('completeAllTasks').addEventListener('click', function() {
    let tasks = JSON.parse(sessionStorage.getItem('tasks')) || [];
    tasks.forEach(task => task.completed = true);
    localStorage.setItem('tasks', JSON.stringify(tasks));
    updateTaskDisplay();
});

// Delete completed tasks
function deleteCompletedTasks() {
    let tasks = JSON.parse(sessionStorage.getItem('tasks')) || [];
    tasks = tasks.filter(task => !task.completed);
    sessionStorage.setItem('tasks', JSON.stringify(tasks));
    updateTaskDisplay();
}

document.getElementById('completeAllTasks').addEventListener('click', completeAllTasks);
document.getElementById('completeAllTasks2').addEventListener('click', completeAllTasks);
document.getElementById('deleteCompletedTasks').addEventListener('click', deleteCompletedTasks);
document.getElementById('deleteCompletedTasks2').addEventListener('click', deleteCompletedTasks);

// Change window to the form
document.getElementById('addNewTask').addEventListener('click', function() {
    window.location.href = 'form.html';
});

document.getElementById('add_task_movile').addEventListener('click', function() {
    window.location.href = 'form.html';
});

// Load tasks when index.html is loaded
if (document.querySelector('.table')) {
    document.addEventListener('DOMContentLoaded', loadTasks);
}

function openMenu() {
    document.getElementById('menu').style.transform = 'translateX(10%)';
    document.getElementById('openMenuButton').style.display = 'none';
    document.getElementById('closeMenuButton').style.display = 'block';
}

function closeMenu() {
    document.getElementById('menu').style.transform = 'translateX(100%)';
    document.getElementById('closeMenuButton').style.display = 'none';
    document.getElementById('openMenuButton').style.display = 'block';
}

// Initialize the menu as closed
document.addEventListener('DOMContentLoaded', function() {
    if (window.innerWidth < 768) {
        closeMenu();
    }
});
