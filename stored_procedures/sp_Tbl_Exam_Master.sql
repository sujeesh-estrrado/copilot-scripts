IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Tbl_Exam_Master]')
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_Tbl_Exam_Master]
            @flag bigint = 0,
            @Exam_Master_id bigint = 0,
            @Duration_Period_id bigint = 0,
            @Exam_Type bigint = 0,
            @Publish_status bigint = 0,
            @exam_status bigint = 0,
            @Final_Exam_status bit = 0,
            @Created_by bigint = 0,
            @Exam_Name varchar(max) = '''',
            @Publish_by bigint = 0,
            @Updated_by bigint = 0,
            @master_id bigint = 0
        AS
        BEGIN
            IF (@flag = 1)
            BEGIN
                IF NOT EXISTS (SELECT * FROM Tbl_Exam_Master
                               WHERE Duration_Period_id = @Duration_Period_id AND [Exam_Type] = @Exam_Type AND delete_status = 0)
                BEGIN
                    INSERT INTO [dbo].[Tbl_Exam_Master] 
                        ([Duration_Period_id], [Exam_Name], [Exam_Type], [Publish_status], [exam_status], 
                         [Create_date], [Created_by], [delete_status], Final_Exam_status, RePublish_status)
                    VALUES 
                        (@Duration_Period_id, @Exam_Name, @Exam_Type, @Publish_status, @exam_status, 
                         Getdate(), @Created_by, 0, @Final_Exam_status, 0)
                    SELECT @@IDENTITY;
                END
                ELSE
                BEGIN
                    SELECT Exam_Master_id FROM Tbl_Exam_Master
                    WHERE Duration_Period_id = @Duration_Period_id AND [Exam_Type] = @Exam_Type AND delete_status = 0;
                END
            END

            IF (@flag = 2)
            BEGIN
                UPDATE [dbo].[Tbl_Exam_Master]
                SET [Duration_Period_id] = @Duration_Period_id,
                    [Exam_Type] = @Exam_Type,
                    [Publish_status] = @Publish_status,
                    [exam_status] = @exam_status,
                    [Updated_by] = @Updated_by,
                    [Update_date] = Getdate()
                WHERE delete_status = 0 AND Exam_Master_id = @master_id;
            END

            IF (@flag = 3)
            BEGIN
                SELECT * FROM Tbl_Exam_Master
                WHERE delete_status = 0 AND Exam_Master_id = @master_id;
            END

            IF (@flag = 4)
            BEGIN
                UPDATE [dbo].[Tbl_Exam_Master]
                SET [Updated_by] = @Updated_by,
                    [Update_date] = Getdate(),
                    Publish_by = @Publish_by,
                    Publish_date = Getdate(),
                    Publish_status = @Publish_status
                WHERE delete_status = 0 AND Exam_Master_id = @master_id;
            END

            IF (@flag = 5)
            BEGIN
                UPDATE [dbo].[Tbl_Exam_Master]
                SET delete_status = 1
                WHERE Exam_Master_id = @Exam_Master_id;
                UPDATE Tbl_Exam_Schedule
                SET Exam_Schedule_Status = 1
                WHERE Exam_Master_Id = @Exam_Master_id;
            END

            IF (@flag = 6)
            BEGIN
                SELECT DISTINCT EM.Exam_Master_id, RePublish_status, P.Batch_Id, D.Department_Id, C.Course_Level_Id, 
                                P.Semester_Id, EM.Exam_Type AS Exam_Type_Id, EM.Publish_status, EM.Exam_Name, 
                                CONVERT(varchar(Max), EM.Create_date, 103) AS exam_createddate, EM.Duration_Period_id, 
                                Final_Exam_status
                FROM Tbl_Exam_Master EM
                LEFT JOIN Tbl_Exam_Schedule ES ON ES.Exam_Master_Id = EM.Exam_Master_id
                INNER JOIN Tbl_Course_Duration_PeriodDetails P ON P.Duration_Period_Id = EM.Duration_Period_id
                INNER JOIN Tbl_Course_Batch_Duration B ON B.Batch_Id = P.Batch_Id
                INNER JOIN Tbl_Department D ON D.Department_Id = B.Duration_Id
                INNER JOIN Tbl_Course_Level C ON C.Course_Level_Id = D.GraduationTypeId
                WHERE EM.Exam_Master_id = @Exam_Master_id;
            END

            IF (@flag = 7)
            BEGIN
                UPDATE [dbo].[Tbl_Exam_Master]
                SET Publish_status = 2, Publish_date = Getdate(), Publish_by = @Updated_by
                WHERE Exam_Master_id = @Exam_Master_id;
                UPDATE Tbl_Exam_Schedule
                SET Is__Published = 1
                WHERE Exam_Master_Id = @Exam_Master_id AND Exam_Schedule_Status = 0;
                SELECT Exam_Master_id FROM Tbl_Exam_Master WHERE Exam_Master_id = @Exam_Master_id;
            END

            IF (@flag = 8)
            BEGIN
                UPDATE [dbo].[Tbl_Exam_Master]
                SET Publish_status = 1
                WHERE Exam_Master_id = @Exam_Master_id;
                SELECT Exam_Master_id FROM Tbl_Exam_Master WHERE Exam_Master_id = @Exam_Master_id;
            END

            IF (@flag = 9)
            BEGIN
                UPDATE Tbl_Exam_Master
                SET RePublish_status = 2
                WHERE Exam_Master_id = @Exam_Master_id;
            END
        END
    ')
END
