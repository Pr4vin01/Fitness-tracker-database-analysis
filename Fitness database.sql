CREATE DATABASE Fitness;

USE Fitness;

-- user table
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    gender VARCHAR(10),
    date_of_birth DATE,
    height_cm DECIMAL(5,2) CHECK (height_cm > 0),
    weight_kg DECIMAL(5,2) CHECK (weight_kg > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- GOAL table
CREATE TABLE Fitness_Goals (
    goal_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    goal_type VARCHAR(50) NOT NULL,
    target_value DECIMAL(10,2) NOT NULL,
    start_date DATE NOT NULL,
    target_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Active',
    
    CONSTRAINT fk_goal_user
        FOREIGN KEY (user_id)
        REFERENCES Users(user_id),
    CONSTRAINT chk_goal_status
        CHECK (status IN ('Active','Completed','Cancelled'))
);

-- workout plans table
CREATE TABLE Workout_Plans (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    plan_name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    created_date DATE NOT NULL,

    CONSTRAINT fk_plan_user
        FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
);

-- Exercises table
CREATE TABLE Exercises (
    exercise_id INT AUTO_INCREMENT PRIMARY KEY,
    exercise_name VARCHAR(100) NOT NULL UNIQUE,
    muscle_group VARCHAR(50) NOT NULL,
    calories_burn_rate DECIMAL(5,2) CHECK (calories_burn_rate >= 0),
    difficulty_level VARCHAR(20),

    CONSTRAINT chk_difficulty
        CHECK (difficulty_level IN ('Beginner','Intermediate','Advanced'))
);

-- Workout_plan_exercise table
CREATE TABLE Workout_Plan_Exercises (
    plan_exercise_id INT AUTO_INCREMENT PRIMARY KEY,
    plan_id INT NOT NULL,
    exercise_id INT NOT NULL,
    sets INT NOT NULL CHECK (sets > 0),
    reps INT NOT NULL CHECK (reps > 0),

    CONSTRAINT fk_wpe_plan
        FOREIGN KEY (plan_id)
        REFERENCES Workout_Plans(plan_id),

    CONSTRAINT fk_wpe_exercise
        FOREIGN KEY (exercise_id)
        REFERENCES Exercises(exercise_id),

    CONSTRAINT uq_plan_exercise
        UNIQUE(plan_id, exercise_id)
);

-- wokrout session table
CREATE TABLE Workout_Sessions (
    session_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    plan_id INT,
    workout_date DATE NOT NULL,
    duration_minutes INT NOT NULL CHECK (duration_minutes > 0),
    calories_burned DECIMAL(8,2) DEFAULT 0,

    CONSTRAINT fk_session_user
        FOREIGN KEY (user_id)
        REFERENCES Users(user_id),

    CONSTRAINT fk_session_plan
        FOREIGN KEY (plan_id)
        REFERENCES Workout_Plans(plan_id)
);

-- Activity table 
CREATE TABLE Activity_Log (
    activity_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    activity_date DATE NOT NULL,
    steps_taken INT DEFAULT 0 CHECK (steps_taken >= 0),
    distance_km DECIMAL(8,2) DEFAULT 0 CHECK (distance_km >= 0),
    calories_burned DECIMAL(8,2) DEFAULT 0 CHECK (calories_burned >= 0),

    CONSTRAINT fk_activity_user
        FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
);

-- Nutrition 
CREATE TABLE Nutrition_Log (
    nutrition_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    meal_date DATE NOT NULL,
    meal_type VARCHAR(20) NOT NULL,
    calories INT NOT NULL CHECK (calories >= 0),
    protein_g DECIMAL(6,2) DEFAULT 0,
    carbs_g DECIMAL(6,2) DEFAULT 0,
    fats_g DECIMAL(6,2) DEFAULT 0,

    CONSTRAINT fk_nutrition_user
        FOREIGN KEY (user_id)
        REFERENCES Users(user_id),

    CONSTRAINT chk_meal_type
        CHECK (meal_type IN ('Breakfast','Lunch','Dinner','Snack'))
);

-- water intake
CREATE TABLE Water_Intake (
    intake_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    intake_date DATE NOT NULL,
    quantity_ml INT NOT NULL CHECK (quantity_ml > 0),

    CONSTRAINT fk_water_user
        FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
     
);

-- Prgress tracking table

CREATE TABLE Progress_Tracking (
    progress_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    record_date DATE NOT NULL,
    weight_kg DECIMAL(5,2) CHECK (weight_kg > 0),
    body_fat_percent DECIMAL(5,2) CHECK (body_fat_percent >= 0),

    CONSTRAINT fk_progress_user
        FOREIGN KEY (user_id)
        REFERENCES Users(user_id),

    CONSTRAINT uq_progress
        UNIQUE(user_id, record_date)
);

-- insert into user table
INSERT INTO Users
(user_id,first_name,last_name,email,gender,date_of_birth,height_cm,weight_kg)
VALUES
(1,'Aisha','Shaikh','aisha@gmail.com','Female','2002-05-10',160,75),
(2,'Rahul','Patil','rahul@gmail.com','Male','2001-08-15',175,85),
(3,'Sneha','Joshi','sneha@gmail.com','Female','2000-03-20',158,65),
(4,'Amit','Sharma','amit@gmail.com','Male','1999-07-12',178,90),
(5,'Priya','Jain','priya@gmail.com','Female','2001-01-18',162,70),
(6,'Rohan','Doshi','rohan@gmail.com','Male','2000-10-05',180,95),
(7,'Neha','Jain','neha@gmail.com','Female','2002-11-25',155,60),
(8,'Arjun','Verma','arjun@gmail.com','Male','1998-12-30',182,88),
(9,'Pooja','Nair','pooja@gmail.com','Female','2001-04-16',165,72),
(10,'Karan','Mehta','karan@gmail.com','Male','2002-06-08',177,82);

-- insert into fitness goals table
INSERT INTO Fitness_Goals
(goal_id,user_id,goal_type,target_value,start_date,target_date,status)
VALUES
(1,1,'Weight Loss',65,'2025-01-01','2025-06-30','Active'),
(2,2,'Weight Loss',75,'2025-01-01','2025-07-01','Active'),
(3,3,'Muscle Gain',70,'2025-01-15','2025-08-01','Active'),
(4,4,'Weight Loss',80,'2025-02-01','2025-08-30','Active'),
(5,5,'Weight Loss',60,'2025-01-10','2025-07-10','Completed'),
(6,6,'Weight Loss',85,'2025-02-01','2025-09-01','Cancelled'),
(7,7,'Muscle Gain',65,'2025-03-01','2025-10-01','Active'),
(8,8,'Weight Loss',78,'2025-01-01','2025-07-01','Completed'),
(9,9,'Weight Loss',65,'2025-02-15','2025-09-15','Active'),
(10,10,'Muscle Gain',88,'2025-03-01','2025-12-01','Active');


-- insert into workout plans
INSERT INTO Workout_Plans
(plan_id,user_id,plan_name,description,created_date)
VALUES
(1,1,'Beginner Fat Loss','Cardio + Diet','2025-02-01'),
(2,2,'Advanced Fat Loss','HIIT Training','2026-01-02'),
(3,3,'Muscle Builder','Strength Training','2026-01-05'),
(4,4,'Weight Loss Program','Cardio Focus','2025-05-06'),
(5,5,'Women Fitness','Mixed Exercises','2026-01-08'),
(6,6,'Cardio Blast','High Intensity','2025-01-10'),
(7,7,'Lean Muscle','Gym Based','2024-01-11'),
(8,8,'Transformation','Strength + Cardio','2025-06-15'),
(9,9,'Healthy Lifestyle','Moderate Activity','2025-01-18'),
(10,10,'Bulk Program','Mass Gain','2026-01-20');

-- insert into exercise
INSERT INTO Exercises
(exercise_id,exercise_name,muscle_group,calories_burn_rate,difficulty_level)
VALUES
(1,'Running','Legs',12,'Beginner'),
(2,'Cycling','Legs',10,'Beginner'),
(3,'Push Ups','Chest',8,'Intermediate'),
(4,'Pull Ups','Back',9,'Advanced'),
(5,'Squats','Legs',11,'Intermediate'),
(6,'Plank','Core',6,'Beginner'),
(7,'Burpees','Full Body',14,'Advanced'),
(8,'Jump Rope','Cardio',13,'Intermediate'),
(9,'Lunges','Legs',10,'Intermediate'),
(10,'Bench Press','Chest',9,'Advanced');

-- insert into workout plan exercises
INSERT INTO Workout_Plan_Exercises
(plan_exercise_id,plan_id,exercise_id,sets,reps)
VALUES
(1,1,1,3,20),
(2,2,7,4,15),
(3,3,10,4,12),
(4,4,2,3,25),
(5,5,5,3,20),
(6,6,8,4,30),
(7,7,4,4,10),
(8,8,3,4,15),
(9,9,6,3,60),
(10,10,10,5,10);

-- insert into workout_session table
INSERT INTO Workout_Sessions
(session_id,user_id,plan_id,workout_date,duration_minutes,calories_burned)
VALUES
(1,1,1,'2025-05-01',45,450),
(2,2,2,'2025-05-01',60,700),
(3,3,3,'2025-05-02',50,500),
(4,4,4,'2025-05-02',55,600),
(5,5,5,'2025-05-03',40,350),
(6,6,6,'2025-05-03',65,750),
(7,7,7,'2025-05-04',45,420),
(8,8,8,'2025-05-04',70,800),
(9,9,9,'2025-05-05',35,300),
(10,10,10,'2025-05-05',75,900);

-- insert into acitivity table
INSERT INTO Activity_Log
(activity_id,user_id,activity_date,steps_taken,distance_km,calories_burned)
VALUES
(1,1,'2025-05-01',8500,6.2,300),
(2,2,'2025-05-01',12000,8.5,450),
(3,3,'2025-05-02',7000,5.0,250),
(4,4,'2025-05-02',10000,7.5,400),
(5,5,'2025-05-03',6500,4.8,220),
(6,6,'2025-05-03',14000,10.2,520),
(7,7,'2025-05-04',8000,5.9,290),
(8,8,'2025-05-04',15000,11.0,600),
(9,9,'2025-05-05',6000,4.2,200),
(10,10,'2025-05-05',13000,9.0,500);

-- insert into nutrition table
INSERT INTO Nutrition_Log
(nutrition_id,user_id,meal_date,meal_type,calories,protein_g,carbs_g,fats_g)
VALUES
(1,1,'2025-05-01','Breakfast',400,20,50,10),
(2,2,'2025-05-01','Lunch',650,35,70,20),
(3,3,'2025-05-02','Dinner',550,30,60,18),
(4,4,'2025-05-02','Breakfast',450,22,55,12),
(5,5,'2025-05-03','Lunch',500,28,58,15),
(6,6,'2025-05-03','Dinner',700,40,80,22),
(7,7,'2025-05-04','Breakfast',380,18,48,9),
(8,8,'2025-05-04','Lunch',750,42,85,25),
(9,9,'2025-05-05','Dinner',520,27,60,16),
(10,10,'2025-05-05','Lunch',800,45,90,28);

-- insert into water intake table
INSERT INTO Water_Intake
(intake_id,user_id,intake_date,quantity_ml)
VALUES
(1,1,'2025-05-01',2500),
(2,2,'2025-05-01',3000),
(3,3,'2025-05-02',2200),
(4,4,'2025-05-02',2800),
(5,5,'2025-05-03',2400),
(6,6,'2025-05-03',3500),
(7,7,'2025-05-04',2300),
(8,8,'2025-05-04',3600),
(9,9,'2025-05-05',2100),
(10,10,'2025-05-05',3200);

-- insert into progress tracking
INSERT INTO Progress_Tracking
(progress_id,user_id,record_date,weight_kg,body_fat_percent)
VALUES
(1,1,'2025-01-01',75,32),
(2,2,'2025-01-01',85,28),
(3,3,'2025-01-01',65,25),
(4,4,'2025-01-01',90,30),
(5,5,'2025-01-01',70,27),
(6,6,'2025-01-01',95,33),
(7,7,'2025-01-01',60,24),
(8,8,'2025-01-01',88,29),
(9,9,'2025-01-01',72,28),
(10,10,'2025-01-01',82,26);


-- using database
USE Fitness;

-- Select query
SELECT * FROM Users;

-- WHERE clause
-- Show female users
SELECT * FROM Users
WHERE gender='Female';

-- Active goals only
SELECT * FROM Fitness_Goals
WHERE status='Active';

-- Aggregate functions
-- SUM()
SELECT SUM(calories_burned) AS total_calories
FROM workout_sessions;

-- AVG()
SELECT AVG(steps_taken)
AS Avg_Steps
FROM Activity_Log;

-- MAX()
SELECT MAX(quantity_ml)
AS Highest_Water_Intake
FROM Water_Intake;

-- MIN()
SELECT MIN(weight_kg) AS minimum_weight
FROM progress_tracking;

-- ORDER BY
-- Most calories burned
SELECT *
FROM Workout_Sessions
ORDER BY calories_burned DESC;

-- GROUP BY 
-- Total water intake per user
SELECT user_id,
SUM(quantity_ml)
AS Water_Intake
FROM Water_Intake
GROUP BY user_id;

-- JOIN 

SELECT e.exercise_name,
COUNT(*) UsageCount
FROM Workout_Plan_Exercises wpe
JOIN Exercises e
ON wpe.exercise_id=e.exercise_id
GROUP BY e.exercise_name
ORDER BY UsageCount DESC;

SELECT *
FROM Water_Intake
WHERE quantity_ml < 2000;


SELECT
u.first_name,
p.weight_kg,
g.target_value
FROM Users u
JOIN Progress_Tracking p
ON u.user_id=p.user_id
JOIN Fitness_Goals g
ON u.user_id=g.user_id;

SELECT 
    COUNT(*) AS Total_Sessions,
    SUM(calories_burned) AS Total_Calories,
    AVG(calories_burned) AS Average_Calories,
    MIN(calories_burned) AS Lowest_Calories,
    MAX(calories_burned) AS Highest_Calories
FROM Workout_Sessions;

SELECT a.user_id, 
SUM(a.steps_taken), u.first_name , u.last_name
FROM Activity_Log a
JOIN users u
ON u.user_id = u.user_id
GROUP BY u.user_id
ORDER BY SUM(a.steps_taken) DESC
LIMIT 5;

SELECT a.user_id, 
SUM(a.steps_taken) AS total_steps, 
u.first_name, u.last_name 
FROM Activity_Log a 
JOIN users u 
ON a.user_id = u.user_id 
GROUP BY a.user_id, u.first_name, u.last_name 
ORDER BY total_steps DESC 
LIMIT 5;

SELECT gender,
AVG(ws.calories_burned)
FROM Users u
JOIN Workout_Sessions ws
ON u.user_id=ws.user_id
GROUP BY gender;


SELECT *
FROM Water_Intake
WHERE quantity_ml < '2000';

SELECT e.exercise_name,
COUNT(*) UsageCount
FROM Workout_Plan_Exercises wpe
JOIN Exercises e
ON wpe.exercise_id=e.exercise_id
GROUP BY e.exercise_name
ORDER BY UsageCount DESC;

SELECT user_id, quantity_ml
 FROM Water_Intake
 where quantity_ml < 2500;

UPDATE Water_Intake
SET quantity_ml = 1800
WHERE intake_id = 9;

DELIMITER //

CREATE PROCEDURE
GetUserWorkoutSessions (IN p_user_id INT)
BEGIN
SELECT u.first_name, wp.plan_name, ws.workout_date, calories_burned 
FROM Workout_Sessions ws
JOIN Users u ON ws.user_id = u.user_id
JOIN Workout_Plans wp ON ws.plan_id = wp.plan_id
WHERE ws.user_id = p_user_id;

END //
DELIMITER ; 

CALL GetUserWorkoutSessions(1);


CREATE TRIGGER GoalCompleted
BEFORE UPDATE
ON Fitness_Goals
FOR EACH ROW
SET NEW.status = 'Completed';

select * from Fitness_Goals 
where goal_id =1

UPDATE Fitness_Goals
SET target_value = 65
WHERE goal_id = 1;

select * from Fitness_Goals 
where goal_id =1


CREATE VIEW UserGoals AS
SELECT user_id, goal_type, status
FROM Fitness_Goals;

SELECT * FROM UserGoals;
use fitness;