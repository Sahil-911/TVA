create schema G5_7;
set search_path to G5_7;

create table User(
	User_id int primary key,
	User_name varchar(20)
);

create table Project(
	Project_id int primary key,
	Project_name varchar(20),
	Manager_id int references User(User_id)
	on update cascade on delete cascade
);

create table Collaborator(
	Project_id int references Project(Project_id)
	on update cascade on delete cascade,
	User_id int references User(User_id)
	on update cascade on delete cascade,
	primary key(Project_id,User_id),
	Role varchar(20)
);

create table Local_files(
	Local_id int primary key,
	Project_id int references Project(Project_id)
	on update cascade on delete cascade,
	User_id int references User(User_id)
	on update cascade on delete set null,
	Timeline_id int references Timeline(Timeline_id)
	on update cascade on delete cascade
);

create table File(
	File_id int,
	Local_id int references Local_files(Local_id)
	on update cascade on delete cascade,
	primary key(File_id,Local_id),
	File_name varchar(20)
);

create table Line(
	Line_id int,
	File_id int references File(File_id)
	on update cascade on delete cascade,
	primary key(Line_id,File_id),
	Content varchar(20)
);

create table Timeline(
	Timeline_id int,
	Project_id int references Project(Project_id)
	on update cascade on delete cascade,
	Latest_version int,
	primary key(Timeline_id,Project_id)
);

create table Version(
	Version_id int,
	Timeline_id int,
	Project_id int references Project(Project_id)
	on update cascade on delete cascade,
	User_id int references User(User_id)
	on update cascade on delete cascade,
	primary key(version_id,Timeline_id)
);

create table Change(
	Previous_id int references Version(Version_id)
	on update cascade on delete cascade,
	Line_id int references Line(Line_id)
	on update cascade on delete cascade,
	primary key(Previous_id,Line_id)
	Prev_content varchar(20),
	New_content varchar(20)
);
