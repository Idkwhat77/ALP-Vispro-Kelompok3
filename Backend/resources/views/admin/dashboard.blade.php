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
            margin-bottom: 2rem;
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
        
        .btn-success {
            background: #28a745;
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
        <!-- Stats Cards -->
        <div class="dashboard-grid">
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

        <!-- Other Teachers' Classes Section -->
        <div class="card">
            <h2>Other Teachers' Classes</h2>
            <p style="color: #666; margin-bottom: 1rem;">View classes created by other teachers (read-only)</p>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Class Name</th>
                            <th>Teacher</th>
                            <th>Student Count</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="other-classes-table">
                        <tr><td colspan="4" class="loading">Loading other classes...</td></tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Class Details Modal -->
    <div id="classDetailsModal" class="modal">
        <div class="modal-content" style="max-width: 800px;">
            <div class="modal-header">
                <h3 id="details-class-name">Class Name</h3>
                <span class="close" onclick="closeClassDetailsModal()">&times;</span>
            </div>
            
            <div class="stats" style="justify-content: flex-start; gap: 2rem;">
                <button class="add-btn" id="btn-add-student-to-class">Add Student to this Class</button>
            </div>

            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Student Name</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="class-students-list">
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Student Modal -->
    <div id="studentModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="student-modal-title">Add Student</h3>
                <span class="close" onclick="document.getElementById('studentModal').style.display='none'">&times;</span>
            </div>
            <form id="student-form">
                <input type="hidden" id="student-id">
                <div class="form-group">
                    <label for="student-name">Student Name:</label>
                    <input type="text" id="student-name" name="student_name" required>
                </div>
                <div class="form-group">
                    <label for="student-class">Class:</label>
                    <select id="student-class" name="classes_id" required>
                        <option value="">Select a class...</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-success" id="student-submit-btn">Add Student</button>
            </form>
        </div>
    </div>

    <!-- Class Modal -->
    <div id="classModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="class-modal-title">Add Class</h3>
                <span class="close" onclick="document.getElementById('classModal').style.display='none'">&times;</span>
            </div>
            <form id="class-form">
                <input type="hidden" id="class-id">
                <div class="form-group">
                    <label for="class-name">Class Name:</label>
                    <input type="text" id="class-name" name="class_name" required>
                </div>
                <button type="submit" class="btn btn-success" id="class-submit-btn">Add Class</button>
            </form>
        </div>
    </div>

    <script>
        let currentUser = null;
        let token = null;
        let allClasses = [];
        let allStudents = [];
        let activeClassId = null;

        document.addEventListener('DOMContentLoaded', function() {
            token = localStorage.getItem('admin_token');
            if (!token) {
                window.location.href = '/admin';
                return;
            }
            loadUserInfo();
            loadDashboardData();
        });

        // API Call function
        async function apiCall(url, method = 'GET', data = null) {
            const options = {
                method,
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${token}`,
                    'Accept': 'application/json'
                }
            };

            if (data && (method === 'POST' || method === 'PUT')) {
                options.body = JSON.stringify(data);
            }

            const response = await fetch(url, options);
            
            if (!response.ok) {
                if (response.status === 401) {
                    localStorage.removeItem('admin_token');
                    window.location.href = '/admin';
                    return;
                }
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            return response.status === 204 ? null : response.json();
        }

        // Load user info
        async function loadUserInfo() {
            try {
                const user = await apiCall('/api/user');
                if (user) {
                    currentUser = user;
                    document.getElementById('teacher-name').textContent = user.username || user.email;
                }
            } catch (error) {
                console.error('Failed to load user info:', error);
                document.getElementById('teacher-name').textContent = 'Unknown User';
            }
        }
        // Load dashboard data
        async function loadDashboardData() {
            try {
                const classesResult = await apiCall('/api/classes');
                if (classesResult && classesResult.success) {
                    allClasses = classesResult.data.own_classes || classesResult.data;
                    
                    const otherClasses = classesResult.data.other_classes || [];
                    
                    // Get students for current teacher's classes
                    const studentsResult = await apiCall('/api/students');
                    if (studentsResult && studentsResult.success) {
                        allStudents = studentsResult.data;
                    }
                    
                    // Get ALL students using the public endpoint to show correct counts for other classes
                    try {
                        const allStudentsResult = await apiCall('/api/public/students');
                        if (allStudentsResult && allStudentsResult.success) {
                            // Use all students for counting other classes
                            updateOtherClassesTable(otherClasses, allStudentsResult.data);
                        } else {
                            // Fallback to current teacher's students only
                            updateOtherClassesTable(otherClasses, allStudents);
                        }
                    } catch (error) {
                        console.error('Failed to load all students:', error);
                        // Fallback to current teacher's students only
                        updateOtherClassesTable(otherClasses, allStudents);
                    }
                }
                
                updateClassesTable(allClasses);
                
                document.getElementById('total-classes').textContent = allClasses.length;
                document.getElementById('total-students').textContent = allStudents.length;
                
            } catch (error) {
                console.error('Failed to load dashboard data:', error);
            }
        }

        // Update the function to accept the students array parameter
        function updateOtherClassesTable(otherClasses, studentsData = allStudents) {
            const tbody = document.getElementById('other-classes-table');
            if (otherClasses.length === 0) {
                tbody.innerHTML = '<tr><td colspan="4">No other classes found</td></tr>';
            } else {
                tbody.innerHTML = otherClasses.map(cls => {
                    // Count students in this class using the provided students data
                    const studentCount = studentsData.filter(s => s.classes_id === cls.classes_id).length;
                    const teacherName = cls.teacher ? cls.teacher.username : `Teacher ID: ${cls.teacher_id}`;
                    
                    return `
                    <tr>
                        <td><strong style="color: #667eea;">${cls.class_name}</strong></td>
                        <td>${teacherName}</td>
                        <td>${studentCount} Students</td>
                        <td>
                            <button class="btn btn-primary" onclick="viewOtherClass(${cls.classes_id}, '${cls.class_name}', '${teacherName}', ${JSON.stringify(studentsData).replace(/"/g, '&quot;')})">View</button>
                        </td>
                    </tr>
                `;
                }).join('');
            }
        }

        // Update viewOtherClass to handle the students data
        function viewOtherClass(classId, className, teacherName, allStudentsData = null) {
            document.getElementById('details-class-name').textContent = `${className} (by ${teacherName})`;
            
            const addBtn = document.getElementById('btn-add-student-to-class');
            addBtn.style.display = 'none';

            // Use all students data if provided, otherwise use current teacher's students
            const studentsToUse = allStudentsData || allStudents;
            const classStudents = studentsToUse.filter(s => s.classes_id === classId);
            
            renderReadOnlyClassStudents(classStudents);
            document.getElementById('classDetailsModal').style.display = 'block';
        }
        
        // Add this function right after the loadDashboardData function
        function updateClassesTable(classes) {
            const tbody = document.getElementById('classes-table');
            if (classes.length === 0) {
                tbody.innerHTML = '<tr><td colspan="3">No classes found</td></tr>';
                return;
            }
            
            tbody.innerHTML = classes.map(cls => {
                const count = allStudents.filter(s => s.classes_id === cls.classes_id).length;
                return `
                <tr>
                    <td><strong style="color: #667eea;">${cls.class_name}</strong></td>
                    <td>${count} Students</td>
                    <td>
                        <button class="btn btn-primary" onclick="manageClass(${cls.classes_id})">Manage</button>
                        <button class="btn btn-primary" onclick="editClass(${cls.classes_id})">Edit</button>
                        <button class="btn btn-danger" onclick="deleteClass(${cls.classes_id})">Delete</button>
                    </td>
                </tr>
                `;
            }).join('');
        }

        // Add this new function to render read-only student list
        function renderReadOnlyClassStudents(students) {
            const tbody = document.getElementById('class-students-list');
            if (students.length === 0) {
                tbody.innerHTML = '<tr><td colspan="2" style="text-align:center; padding: 2rem;">No students in this class.</td></tr>';
                return;
            }

            tbody.innerHTML = students.map(student => `
                <tr>
                    <td>${student.student_name}</td>
                    <td><em style="color: #666;">Read-only access</em></td>
                </tr>
            `).join('');
        }

        // Update the existing manageClass function to ensure Add button shows for own classes
        function manageClass(classId) {
            const cls = allClasses.find(c => c.classes_id === classId);
            if (!cls) return;

            activeClassId = classId;
            document.getElementById('details-class-name').textContent = cls.class_name;
            
            // Show the "Add Student" button for own classes
            const addBtn = document.getElementById('btn-add-student-to-class');
            addBtn.style.display = 'block';
            addBtn.onclick = () => openAddStudentModal(classId);

            const classStudents = allStudents.filter(s => s.classes_id === classId);
            renderClassStudents(classStudents);

            document.getElementById('classDetailsModal').style.display = 'block';
        }

        function renderClassStudents(students) {
            const tbody = document.getElementById('class-students-list');
            if (students.length === 0) {
                tbody.innerHTML = '<tr><td colspan="2" style="text-align:center; padding: 2rem;">No students in this class yet.</td></tr>';
                return;
            }

            tbody.innerHTML = students.map(student => `
                <tr>
                    <td>${student.student_name}</td>
                    <td>
                        <button class="btn btn-primary" onclick="editStudent(${student.id_students})">Edit</button>
                        <button class="btn btn-danger" onclick="deleteStudent(${student.id_students})">Remove</button>
                    </td>
                </tr>
            `).join('');
        }

        function closeClassDetailsModal() {
            document.getElementById('classDetailsModal').style.display = 'none';
            activeClassId = null;
        }

        // Student Modal Functions
        function openAddStudentModal(preSelectedClassId = null) {
            document.getElementById('student-modal-title').textContent = 'Add New Student';
            document.getElementById('student-submit-btn').textContent = 'Add Student';
            document.getElementById('student-form').reset();
            document.getElementById('student-id').value = '';
            
            populateClassOptions();
            
            const classSelect = document.getElementById('student-class');
            if (preSelectedClassId) {
                classSelect.value = preSelectedClassId;
                classSelect.disabled = true;
            } else {
                classSelect.disabled = false;
            }

            document.getElementById('studentModal').style.display = 'block';
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

        function editStudent(studentId) {
            const student = allStudents.find(s => s.id_students === studentId);
            if (!student) return;

            document.getElementById('student-modal-title').textContent = 'Edit Student';
            document.getElementById('student-submit-btn').textContent = 'Update Student';
            document.getElementById('student-id').value = studentId;
            document.getElementById('student-name').value = student.student_name;
            
            populateClassOptions();
            document.getElementById('student-class').value = student.classes_id;
            document.getElementById('student-class').disabled = false;

            document.getElementById('studentModal').style.display = 'block';
        }

        // Student form submission
        document.getElementById('student-form').addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const nameInput = document.getElementById('student-name').value;
            const classSelect = document.getElementById('student-class');
            const classId = classSelect.disabled ? activeClassId : parseInt(classSelect.value);
            const studentId = document.getElementById('student-id').value;

            const data = {
                student_name: nameInput,
                classes_id: classId
            };

            try {
                if (studentId) {
                    await apiCall(`/api/students/${studentId}`, 'PUT', data);
                    alert('Student updated!');
                } else {
                    await apiCall('/api/students', 'POST', data);
                    alert('Student added!');
                }
                
                document.getElementById('studentModal').style.display = 'none';
                await loadDashboardData();
                
                if (activeClassId) {
                    manageClass(activeClassId);
                }

            } catch (error) {
                console.error('Error:', error);
                alert('Something went wrong!');
            }
        });

        // Class Functions
        function addClass() {
            document.getElementById('class-modal-title').textContent = 'Add New Class';
            document.getElementById('class-submit-btn').textContent = 'Add Class';
            document.getElementById('class-form').reset();
            document.getElementById('class-id').value = '';
            document.getElementById('classModal').style.display = 'block';
        }

        function editClass(classId) {
            const cls = allClasses.find(c => c.classes_id === classId);
            if (!cls) return;

            document.getElementById('class-modal-title').textContent = 'Edit Class';
            document.getElementById('class-submit-btn').textContent = 'Update Class';
            document.getElementById('class-id').value = classId;
            document.getElementById('class-name').value = cls.class_name;
            document.getElementById('classModal').style.display = 'block';
        }

        // Class form submission
        document.getElementById('class-form').addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const className = document.getElementById('class-name').value;
            const classId = document.getElementById('class-id').value;

            const data = {
                class_name: className,
                teacher_id: currentUser?.teacher_id
            };

            try {
                if (classId) {
                    await apiCall(`/api/classes/${classId}`, 'PUT', data);
                    alert('Class updated!');
                } else {
                    await apiCall('/api/classes', 'POST', data);
                    alert('Class added!');
                }
                
                document.getElementById('classModal').style.display = 'none';
                await loadDashboardData();

            } catch (error) {
                console.error('Error:', error);
                alert('Something went wrong!');
            }
        });

        // Delete Functions
        async function deleteStudent(id) {
            if (confirm("Remove this student?")) {
                try {
                    await apiCall(`/api/students/${id}`, 'DELETE');
                    await loadDashboardData();
                    if (activeClassId) manageClass(activeClassId);
                    alert('Student removed!');
                } catch (error) {
                    console.error('Error:', error);
                    alert('Failed to remove student');
                }
            }
        }

        async function deleteClass(id) {
            if (confirm("Delete this class? This will also remove all students in this class.")) {
                try {
                    await apiCall(`/api/classes/${id}`, 'DELETE');
                    await loadDashboardData();
                    alert('Class deleted!');
                } catch (error) {
                    console.error('Error:', error);
                    alert('Failed to delete class');
                }
            }
        }

        // Logout function
        async function logout() {
            try {
                await apiCall('/api/logout', 'POST');
            } catch (error) {
                console.error('Logout error:', error);
            } finally {
                localStorage.removeItem('admin_token');
                window.location.href = '/admin';
            }
        }

        // Close modals on outside click
        window.onclick = function(event) {
            if (event.target == document.getElementById('studentModal')) {
                document.getElementById('studentModal').style.display = 'none';
            }
            if (event.target == document.getElementById('classDetailsModal')) {
                closeClassDetailsModal();
            }
            if (event.target == document.getElementById('classModal')) {
                document.getElementById('classModal').style.display = 'none';
            }
        }
    </script>
</body>
</html>