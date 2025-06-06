IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[ReEvaluation_Fee_Setting]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[ReEvaluation_Fee_Setting]    
        (    
            @Flag bigint = 0,    
            @ID bigint = 0,    
            @BatchID bigint = 0,    
            @ReEvaluation_Fee decimal(18, 2) = 0,    
            @Emp bigint = 0,    
            @IntakeMaster bigint = 0,    
            @Department_Id bigint = 0,    
            @Delete_Status int = 0    
        )    
        AS    
        BEGIN    
            IF(@Flag = 1) -- Insert    
            BEGIN    
                SET @BatchID = (SELECT TOP 1 [Batch_Id] FROM [dbo].[Tbl_Course_Batch_Duration]    
                    WHERE [IntakeMasterID] = @IntakeMaster    
                    AND [Duration_Id] = @Department_Id    
                    AND [Batch_DelStatus] = 0)    
                IF @BatchID IS NOT NULL    
                BEGIN    
                    IF NOT EXISTS (SELECT * FROM [dbo].[Tbl_ReEvaluation_Fee_Setting]     
                        WHERE [BatchID] = @BatchID    
                        AND [Delete_Status] = 0)    
                    BEGIN    
                        INSERT INTO [dbo].[Tbl_ReEvaluation_Fee_Setting]    
                            ([BatchID], [ReEvaluation_Fee], [Delete_Status], [Create_Date], [Update_Date], [Emp])    
                        VALUES    
                            (@BatchID, @ReEvaluation_Fee, 0, GETDATE(), GETDATE(), @Emp)    
                    END    
                    ELSE    
                    BEGIN    
                        UPDATE [dbo].[Tbl_ReEvaluation_Fee_Setting]    
                        SET [ReEvaluation_Fee] = @ReEvaluation_Fee,    
                            [Emp] = @Emp,    
                            [Update_Date] = GETDATE()    
                        WHERE [BatchID] = @BatchID    
                    END    
                END    
            END    
            IF(@Flag = 2) -- Update ReEvaluation_Fee    
            BEGIN    
                UPDATE [dbo].[Tbl_ReEvaluation_Fee_Setting]    
                SET [ReEvaluation_Fee] = @ReEvaluation_Fee,    
                    [Update_Date] = GETDATE(),    
                    [Emp] = @Emp    
                WHERE [ID] = @ID    
            END    
            IF(@Flag = 3) -- Delete ReEvaluation_Fee    
            BEGIN    
                UPDATE [dbo].[Tbl_ReEvaluation_Fee_Setting]    
                SET [Delete_Status] = 1,    
                    [Update_Date] = GETDATE(),    
                    [Emp] = @Emp    
                WHERE [ID] = @ID    
            END    
            IF(@Flag = 4) -- Select ReEvaluation_Fee Settings By Program_Type_Id, DepartmentID    
            BEGIN    
                SELECT RFS.*, D.[Department_Id], D.[Program_Type_Id], 
                       CONCAT(D.[Course_Code], ''-'', D.[Department_Name]) AS [Department_Name], 
                       IM.[Batch_Code]    
                FROM [dbo].[Tbl_ReEvaluation_Fee_Setting] RFS    
                LEFT JOIN [dbo].[Tbl_Course_Batch_Duration] CBD ON CBD.[Batch_Id] = RFS.[BatchID]    
                LEFT JOIN [dbo].[Tbl_Department] D ON D.[Department_Id] = CBD.[Duration_Id]    
                LEFT JOIN [dbo].[Tbl_IntakeMaster] IM ON IM.[id] = CBD.[IntakeMasterID]    
                WHERE RFS.[Delete_Status] = 0    
                AND (@IntakeMaster = 0 OR CBD.[IntakeMasterID] = @IntakeMaster)    
                AND (D.[Department_Id] = @Department_Id OR @Department_Id = 0)    
            END    
            IF(@Flag = 5) -- Select ReEvaluation_Fee Settings Department ID    
            BEGIN    
                SELECT RFS.*, D.[Department_Id], D.[Program_Type_Id]    
                FROM [dbo].[Tbl_ReEvaluation_Fee_Setting] RFS    
                JOIN [dbo].[Tbl_Course_Batch_Duration] CBD ON CBD.[Batch_Id] = RFS.[BatchID]    
                JOIN [dbo].[Tbl_Department] D ON D.[Department_Id] = CBD.[Duration_Id]    
                WHERE RFS.[Delete_Status] = 0    
                AND (D.[Department_Id] = @Department_Id)    
            END    
        END
    ')
END
