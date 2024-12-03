<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <title>Create Account</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
        }
        .container {
            text-align: center;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 600px;
        }
        label, p {
            font-size: 16px;
            color: #333;
        }
        input[type="text"], input[type="password"], input[type="email"] {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        button {
            width: 100%;
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-top: 10px;
        }
        button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class="container">
        <p>Please enter the account credentials:</p>
        <!-- TODO: create registerCustomerRepresentative.jsp  -->
        <form action="registerCustomerRepresentative.jsp" method="post">
            <label for="f_name">First Name:</label>
            <input type="text" name="f_name" id="f_name" required>
            
            <label for="l_name">Last Name:</label>
            <input type="text" name="l_name" id="l_name" required>
            
            <label for="ssn">SSN:</label>
			<input type="text" name="ssn" id="ssn" placeholder="XXX-XX-XXXX" required>
			
            <label for="username">Username:</label>
            <input type="text" name="username" id="username" required>
            
            <label for="password">Password:</label>
            <input type="password" name="password" id="password" required>
            
            <button type="submit">Create Account</button>
            
        </form>
        <form action="adminHome.jsp">
            <button type="submit">Back to Home</button>
        </form>
    </div>
</body>
</html>


