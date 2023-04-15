CREATE SCHEMA DBMS_PROJECT;
SET search_path TO DBMS_PROJECT;

CREATE TABLE "User" (
    User_id INT NOT NULL,
    User_name VARCHAR(20) NOT NULL
);

CREATE TABLE Project (
    Project_id INT NOT NULL,
    Project_name VARCHAR(20) NOT NULL,
    Manager_id INT NOT NULL
);

CREATE TABLE Collaborator (
    Project_id INT NOT NULL,
    User_id INT NOT NULL,
    Role VARCHAR(20) NOT NULL
);

CREATE TABLE Local_Files (
    Local_id INT NOT NULL,
    Project_id INT NOT NULL,
    User_id INT,
    Timeline_id INT SET DEFAULT 0 NOT NULL
);

CREATE TABLE "File" (
    File_id INT NOT NULL,
    Local_id INT NOT NULL,
    Project_id INT NOT NULL,
    File_name VARCHAR(20) NOT NULL,
    Length INT NOT NULL
);

CREATE TABLE "Line" (
    Line_id INT NOT NULL,
    File_id INT NOT NULL,
    Local_id INT NOT NULL,
    Project_id INT NOT NULL,
    Content VARCHAR(1024) NOT NULL
);

CREATE TABLE Timeline (
    Timeline_id INT NOT NULL,
    Project_id INT NOT NULL,
    Latest_Version VARCHAR(20) NOT NULL,
    Latest_Files VARCHAR(20) NOT NULL
);

CREATE TABLE "Version" (
    Version_id INT NOT NULL,
    Timeline_id INT NOT NULL,
    Project_id INT NOT NULL,
    Updater_id INT NOT NULL
);

CREATE TABLE Change (
    Version_id INT NOT NULL,
    Timeline_id INT NOT NULL,
    Project_id INT NOT NULL,
    Line_id INT NOT NULL,
    File_id INT NOT NULL,
    Previous_content VARCHAR(1024) NOT NULL,
    New_content VARCHAR(1024) NOT NULL
);

ALTER TABLE Collaborator
    ADD FOREIGN KEY (Project_id) REFERENCES Project(Project_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    ADD FOREIGN KEY (User_id) REFERENCES "User"(User_id)
    ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE Local_Files
    ADD FOREIGN KEY (Project_id) REFERENCES Project(Project_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    ADD FOREIGN KEY (User_id) REFERENCES "User"(User_id)
    ON DELETE SET NULL ON UPDATE CASCADE;
    ADD FOREIGN KEY (Timeline_id) REFERENCES Timeline(Timeline_id)
    ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE "File"
    ADD FOREIGN KEY (Local_id) REFERENCES Local_Files(Local_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    ADD FOREIGN KEY (Project_id) REFERENCES Project(Project_id)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "Line"
    ADD FOREIGN KEY (File_id) REFERENCES "File"(File_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    ADD FOREIGN KEY (Local_id) REFERENCES Local_Files(Local_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    ADD FOREIGN KEY (Project_id) REFERENCES Project(Project_id)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Timeline
    ADD FOREIGN KEY (Project_id) REFERENCES Project(Project_id)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "Version"
    ADD FOREIGN KEY (Timeline_id) REFERENCES Timeline(Timeline_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    ADD FOREIGN KEY (Project_id) REFERENCES Project(Project_id)
    ON DELETE CASCADE ON UPDATE CASCADE;
     
ALTER TABLE Change
    ADD FOREIGN KEY (Version_id) REFERENCES "Version"(Version_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    ADD FOREIGN KEY (Timeline_id) REFERENCES Timeline(Timeline_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    ADD FOREIGN KEY (Project_id) REFERENCES Project(Project_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    ADD FOREIGN KEY (Line_id) REFERENCES "Line"(Line_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    ADD FOREIGN KEY (File_id) REFERENCES "File"(File_id)
    ON DELETE CASCADE ON UPDATE CASCADE;
