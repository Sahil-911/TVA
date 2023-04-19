--push query
-- make a new version vn
-- set latest_version to vn
--compare with the latest local of timeline and add change to the change table set version id to vn
-- make a new local
-- set timeline(timeline#n)'s latest local to local#n
-- add all files & lines with "local#n,project#n" to the new local


--pull query
--remove all files with local#n
--copy all files & lines from the "latest local of timeline" to local#n
-- revert one version back
-- do all the changes to latest_local (line table)


-- add a line to file
INSERT INTO "Line" (
          "Line_id",
          "File_id",
          "local_id",
          "Project_id",
          "Content"
     )
VALUES ("line#n", "file#n", "local#n", "project#n", "content");

UPDATE "File" SET  length = length + 1 WHERE "File_id" = "file#n";

