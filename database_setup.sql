-- Database setup for TaskMate with JWT authentication

-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS taskmate;
USE taskmate;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create tokens table for JWT token storage
CREATE TABLE IF NOT EXISTS tokens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    token TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create tasks table with user_id foreign key
CREATE TABLE IF NOT EXISTS tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status ENUM('To Do', 'In Progress', 'Done') DEFAULT 'To Do',
    priority ENUM('Low', 'Medium', 'High') DEFAULT 'Low',
    due_date DATE,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Add indexes for better performance
CREATE INDEX idx_tasks_user_id ON tasks(user_id);
CREATE INDEX idx_tokens_user_id ON tokens(user_id);
CREATE INDEX idx_tokens_token ON tokens(token);
CREATE INDEX idx_users_email ON users(email);

-- Insert sample user (password: 'password123' - hashed with bcrypt)
-- You can remove this after testing
INSERT INTO users (full_name, email, password) VALUES 
('Test User', 'test@example.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi')
ON DUPLICATE KEY UPDATE full_name = full_name;

-- Insert sample tasks for the test user
INSERT INTO tasks (title, description, status, priority, due_date, user_id) VALUES 
('Complete Project Proposal', 'Write and submit the project proposal document', 'In Progress', 'High', DATE_ADD(CURDATE(), INTERVAL 3 DAY), 1),
('Review Code Changes', 'Review pull requests and provide feedback', 'To Do', 'Medium', DATE_ADD(CURDATE(), INTERVAL 1 DAY), 1),
('Team Meeting', 'Weekly team sync meeting', 'Done', 'Low', CURDATE(), 1)
ON DUPLICATE KEY UPDATE title = title; 