<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teacher Dashboard</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
        }
        
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .header h1 {
            font-size: 1.5rem;
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .logout-btn {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
            padding: 0.5rem 1rem;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.3s;
        }
        
        .logout-btn:hover {
            background: rgba(255, 255, 255, 0.1);
        }
        
        .container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 2rem;
        }
        
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-bottom: 2rem;
        }
        
        .card {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .card h2 {
            color: #333;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #eee;
        }
        
        .stats {
            display: flex;
            justify-content: space-between;
            margin-bottom: 1rem;
        }
        
        .stat-item {
            text-align: center;
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: #667eea;
        }
        
        .stat-label {
            color: #666;
            font-size: 0.9rem;
        }
        
        .table-container {
            overflow-x: auto;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }
        
        th, td {
            padding: 0.75rem;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        th {
            background: #f8f9fa;
            font-weight: 600;
            color: #333;
        }
        
        .btn {
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 0.9rem;
            margin: 0 0.25rem;
        }
        
        .btn-primary {
            background: #667eea;
            color: white;
        }
        
        .btn-danger {
            background: #dc3545;
            color: white;
        }
        
        .btn:hover {
            opacity: 0.8;
        }
        
        .add-btn {
            background: #28a745;
            color: white;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-bottom: 1rem;
        }
        
        .loading {
            text-align: center;
            padding: 2rem;
            color: #666;
        }
        
        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
        }
        
        .modal-content {
            background-color: white;
            margin: 5% auto;
            padding: 2rem;
            border-radius: 10px;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
        }
        
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #eee;
        }
        
        .close {
            color: #aaa;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            line-height: 1;
        }
        
        .close:hover {
            color: #000;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: #333;
            font-weight: 600;
        }
        
        .form-group input, .form-group select {
            width: 100%;
            padding: 0.75rem;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 1rem;
            transition: border-color 0.3s;
        }
        
        .form-group input:focus, .form-group select:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .class-info {
            background: #f8f9fa;
            padding: 1rem;
            border-radius: 5px;
            margin-bottom: 1rem;
            border-left: 4px solid #667eea;
        }
        
        .class-info strong {
            color: #333;
        }
        
        .btn-success {
            background: #28a745;
            color: white;
            width: 100%;
            padding: 0.75rem;
            margin-top: 1rem;
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
            margin-left: 0.5rem;
        }
    </style>
</head>
<body>
    <header class="header">
        <h1>Teacher Dashboard</h1>
        <div class="user-info">
            <span id="teacher-name">Loading...</span>
            <button class="logout-btn" onclick="logout()">Logout</button>
        </div>
    </header>
    
    <div class="container">
        <div class="dashboard-grid">
            <!-- Stats Card -->
            <div class="card">
                <h2>Overview</h2>
                <div class="stats">
                    <div class="stat-item">
                        <div class="stat-number" id="total-classes">0</div>
                        <div class="stat-label">Classes</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number" id="total-students">0</div>
                        <div class="stat-label">Students</div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Classes Section -->
        <div class="card">
            <h2>My Classes</h2>
            <button class="add-btn" onclick="addClass()">Add New Class</button>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Class Name</th>
                            <th>Student Count</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="classes-table">
                        <tr><td colspan="3" class="loading">Loading classes...</td></tr>
                    </tbody>
                </table>
            </div>
        </div>
        
        <!-- Students Section -->
        <div class="card">
            <h2>My Students</h2>
            <button class="add-btn" onclick="addStudent()">Add New Student</button>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Student Name</th>
                            <th>Class</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="students-table">
                        <tr><td colspan="3" class="loading">Loading students...</td></tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Student Modal -->
    <div id="studentModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="student-modal-title">Add New Student</h3>
                <span class="close" onclick="closeStudentModal()">&times;</span>
            </div>
            
            <div id="current-class-info" class="class-info" style="display: none;">
                <strong>Current Class:</strong> <span id="current-class-name"></span>
            </div>
            
            <form id="student-form">
                <input type="hidden" id="student-id" name="student_id">
                
                <div class="form-group">
                    <label for="student-name">Student Name</label>
                    <input type="text" id="student-name" name="student_name" required>
                </div>
                
                <div class="form-group">
                    <label for="student-class">Class</label>
                    <select id="student-class" name="classes_id" required>
                        <option value="">Select a class...</option>
                    </select>
                </div>
                
                <button type="submit" class="btn btn-success" id="student-submit-btn">
                    Add Student
                </button>
                <button type="button" class="btn btn-secondary" onclick="closeStudentModal()">
                    Cancel
                </button>
            </form>
        </div>
    </div>

    <script>
        let currentUser = null;
        let token = null;
        let allClasses = [];
        let allStudents = [];
        
        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            token = localStorage.getItem('admin_token');
            if (!token) {
                window.location.href = '/admin';
                return;
            }
            
            loadUserInfo();
            loadDashboardData();
        });
        
        async function apiCall(url, method = 'GET', data = null) {
            const options = {
                method,
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Accept': 'application/json',
                    'Content-Type': 'application/json'
                }
            };
            
            if (data) {
                options.body = JSON.stringify(data);
            }
            
            const response = await fetch(url, options);
            
            if (response.status === 401) {
                localStorage.removeItem('admin_token');
                localStorage.removeItem('admin_user');
                window.location.href = '/admin';
                return null;
            }
            
            return await response.json();
        }
        
        async function loadUserInfo() {
            try {
                const result = await apiCall('/api/admin/me');
                if (result && result.success) {
                    currentUser = result.teacher;
                    document.getElementById('teacher-name').textContent = currentUser.username;
                }
            } catch (error) {
                console.error('Failed to load user info:', error);
            }
        }
        
        async function loadDashboardData() {
            try {
                // Load classes
                const classesResult = await apiCall('/api/classes');
                if (classesResult && classesResult.success) {
                    allClasses = classesResult.data.own_classes || classesResult.data;
                    updateClassesTable(allClasses);
                    populateClassOptions();
                }
                
                // Load students
                const studentsResult = await apiCall('/api/students');
                if (studentsResult && studentsResult.success) {
                    allStudents = studentsResult.data;
                    updateStudentsTable(allStudents);
                }
                
                // Update stats
                document.getElementById('total-classes').textContent = allClasses.length;
                document.getElementById('total-students').textContent = allStudents.length;
                
            } catch (error) {
                console.error('Failed to load dashboard data:', error);
            }
        }
        
        function updateClassesTable(classes) {
            const tbody = document.getElementById('classes-table');
            if (classes.length === 0) {
                tbody.innerHTML = '<tr><td colspan="3">No classes found</td></tr>';
                return;
            }
            
            tbody.innerHTML = classes.map(cls => `
                <tr>
                    <td>${cls.class_name}</td>
                    <td>${allStudents.filter(s => s.classes_id === cls.classes_id).length}</td>
                    <td>
                        <button class="btn btn-primary" onclick="editClass(${cls.classes_id})">Edit</button>
                        <button class="btn btn-danger" onclick="deleteClass(${cls.classes_id})">Delete</button>
                    </td>
                </tr>
            `).join('');
        }
        
        function updateStudentsTable(students) {
            const tbody = document.getElementById('students-table');
            if (students.length === 0) {
                tbody.innerHTML = '<tr><td colspan="3">No students found</td></tr>';
                return;
            }
            
            tbody.innerHTML = students.map(student => {
                const studentClass = allClasses.find(c => c.classes_id === student.classes_id);
                const className = studentClass ? studentClass.class_name : 'Unknown Class';
                
                return `
                    <tr>
                        <td>${student.student_name}</td>
                        <td>${className}</td>
                        <td>
                            <button class="btn btn-primary" onclick="editStudent(${student.id_students})">Edit</button>
                            <button class="btn btn-danger" onclick="deleteStudent(${student.id_students})">Delete</button>
                        </td>
                    </tr>
                `;
            }).join('');
        }
        
        function populateClassOptions() {
            const select = document.getElementById('student-class');
            select.innerHTML = '<option value="">Select a class...</option>';
            
            allClasses.forEach(cls => {
                const option = document.createElement('option');
                option.value = cls.classes_id;
                option.textContent = cls.class_name;
                select.appendChild(option);
            });
        }
        
        // Action functions
        function addClass() {
            const className = prompt('Enter class name:');
            if (className) {
                apiCall('/api/classes', 'POST', { class_name: className })
                    .then(() => {
                        alert('Class added successfully!');
                        loadDashboardData();
                    })
                    .catch(error => {
                        console.error('Error adding class:', error);
                        alert('Failed to add class');
                    });
            }
        }
        
        function addStudent() {
            if (allClasses.length === 0) {
                alert('Please create a class first before adding students.');
                return;
            }
            
            document.getElementById('student-modal-title').textContent = 'Add New Student';
            document.getElementById('student-submit-btn').textContent = 'Add Student';
            document.getElementById('student-form').reset();
            document.getElementById('student-id').value = '';
            document.getElementById('current-class-info').style.display = 'none';
            document.getElementById('studentModal').style.display = 'block';
        }
        
        function editClass(id) {
            const cls = allClasses.find(c => c.classes_id === id);
            if (cls) {
                const newName = prompt('Enter new class name:', cls.class_name);
                if (newName && newName !== cls.class_name) {
                    apiCall(`/api/classes/${id}`, 'PUT', { class_name: newName })
                        .then(() => {
                            alert('Class updated successfully!');
                            loadDashboardData();
                        })
                        .catch(error => {
                            console.error('Error updating class:', error);
                            alert('Failed to update class');
                        });
                }
            }
        }
        
        function editStudent(id) {
            const student = allStudents.find(s => s.id_students === id);
            if (student) {
                const currentClass = allClasses.find(c => c.classes_id === student.classes_id);
                
                document.getElementById('student-modal-title').textContent = 'Edit Student';
                document.getElementById('student-submit-btn').textContent = 'Update Student';
                document.getElementById('student-id').value = student.id_students;
                document.getElementById('student-name').value = student.student_name;
                document.getElementById('student-class').value = student.classes_id;
                
                // Show current class info
                if (currentClass) {
                    document.getElementById('current-class-name').textContent = currentClass.class_name;
                    document.getElementById('current-class-info').style.display = 'block';
                }
                
                document.getElementById('studentModal').style.display = 'block';
            }
        }
        
        function deleteClass(id) {
            const cls = allClasses.find(c => c.classes_id === id);
            const studentsInClass = allStudents.filter(s => s.classes_id === id).length;
            
            let confirmMessage = `Are you sure you want to delete "${cls.class_name}"?`;
            if (studentsInClass > 0) {
                confirmMessage += `\n\nThis will also delete ${studentsInClass} student(s) in this class.`;
            }
            
            if (confirm(confirmMessage)) {
                apiCall(`/api/classes/${id}`, 'DELETE')
                    .then(() => {
                        alert('Class deleted successfully!');
                        loadDashboardData();
                    })
                    .catch(error => {
                        console.error('Error deleting class:', error);
                        alert('Failed to delete class');
                    });
            }
        }
        
        function deleteStudent(id) {
            const student = allStudents.find(s => s.id_students === id);
            if (confirm(`Are you sure you want to delete "${student.student_name}"?`)) {
                apiCall(`/api/students/${id}`, 'DELETE')
                    .then(() => {
                        alert('Student deleted successfully!');
                        loadDashboardData();
                    })
                    .catch(error => {
                        console.error('Error deleting student:', error);
                        alert('Failed to delete student');
                    });
            }
        }
        
        // Modal functions
        function closeStudentModal() {
            document.getElementById('studentModal').style.display = 'none';
        }
        
        // Student form submission
        document.getElementById('student-form').addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const formData = new FormData(this);
            const data = {
                student_name: formData.get('student_name'),
                classes_id: parseInt(formData.get('classes_id'))
            };
            
            const studentId = formData.get('student_id');
            const isEditing = studentId && studentId !== '';
            
            try {
                if (isEditing) {
                    await apiCall(`/api/students/${studentId}`, 'PUT', data);
                    alert('Student updated successfully!');
                } else {
                    await apiCall('/api/students', 'POST', data);
                    alert('Student added successfully!');
                }
                
                closeStudentModal();
                loadDashboardData();
            } catch (error) {
                console.error('Error saving student:', error);
                alert('Failed to save student');
            }
        });
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('studentModal');
            if (event.target === modal) {
                closeStudentModal();
            }
        };
        
        function logout() {
            apiCall('/api/admin/logout', 'POST')
                .finally(() => {
                    localStorage.removeItem('admin_token');
                    localStorage.removeItem('admin_user');
                    window.location.href = '/admin';
                });
        }
    </script>
</body>
</html>