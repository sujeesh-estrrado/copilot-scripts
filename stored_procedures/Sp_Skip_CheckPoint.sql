IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Skip_CheckPoint]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Skip_CheckPoint]
        (
            @flag BIGINT,
            @Request_remark VARCHAR(MAX),
            @Requested_by BIGINT,
            @Approved_remark VARCHAR(MAX),
            @Approved_by BIGINT,
            @Approval_status BIGINT,
            @id BIGINT,
            @candidate_id BIGINT
        )
        AS
        BEGIN
            -- approval status 1=pending
            -- 2=approved
            -- 3=rejected

            IF (@flag = 1) -- insert request
            BEGIN
                IF NOT EXISTS (
                    SELECT * 
                    FROM [Tbl_Skip_CheckPoint] 
                    WHERE candidate_id = @candidate_id 
                    AND (Approval_status = 1 OR Approval_status = 2) 
                    AND delete_status = 0
                )
                BEGIN
                    INSERT INTO [dbo].[Tbl_Skip_CheckPoint] 
                    (
                        [Request_remark], candidate_id, 
                        [Requested_by], [Requested_date], 
                        [Approval_status], [delete_status]
                    ) 
                    VALUES 
                    (
                        @Request_remark, @candidate_id, @Requested_by, GETDATE(), 
                        @Approval_status, 0
                    )
                END
            END

            IF (@flag = 2) -- approve/reject request
            BEGIN
                UPDATE Tbl_Skip_CheckPoint 
                SET 
                    [Approved_remark] = @Approved_remark,
                    [Approved_by] = @Approved_by,
                    [Approval_status] = @Approval_status,
                    [Approved_date] = GETDATE()
                WHERE candidate_id = @candidate_id 
                AND delete_status = 0
            END

            IF (@flag = 3)
            BEGIN
                SELECT 
                    Request_remark,
                    CONVERT(VARCHAR, Requested_date, 103) AS Requested_date,
                    CASE 
                        WHEN CONCAT(e.employee_fname, '' '', e.Employee_LName) = '''' 
                        THEN ''Admin'' 
                        ELSE CONCAT(e.employee_fname, '' '', e.Employee_LName) 
                    END AS requested_by, 
                    Approval_status 
                FROM Tbl_Skip_CheckPoint sc
                LEFT JOIN Tbl_Employee_User eu ON eu.user_id = sc.requested_by
                LEFT JOIN Tbl_Employee e ON e.Employee_Id = eu.Employee_Id 
                WHERE candidate_id = @candidate_id 
                AND delete_status = 0 
                AND (Approval_status = 1 OR Approval_status = 2)
            END

            IF (@flag = 4)
            BEGIN
                SELECT 
                    Request_remark,
                    CONVERT(VARCHAR, Requested_date, 103) AS Requested_date,
                    CASE 
                        WHEN CONCAT(e.employee_fname, '' '', e.Employee_LName) = '''' 
                        THEN ''Admin'' 
                        ELSE CONCAT(e.employee_fname, '' '', e.Employee_LName) 
                    END AS requested_by, 
                    Approval_status 
                FROM Tbl_Skip_CheckPoint sc
                LEFT JOIN Tbl_Employee_User eu ON eu.user_id = sc.requested_by
                LEFT JOIN Tbl_Employee e ON e.Employee_Id = eu.Employee_Id 
                WHERE candidate_id = @candidate_id 
                AND delete_status = 0
                ORDER BY id DESC
            END
        END
    ')
END
