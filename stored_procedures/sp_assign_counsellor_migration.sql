IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_assign_counsellor_migration]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_assign_counsellor_migration]
        (
            @id bigint, 
            @type varchar(max), 
            @role bigint
        )
        AS
        BEGIN
            IF EXISTS (SELECT * FROM Tbl_RoleAssignment WHERE employee_id = @id)
            BEGIN
                UPDATE Tbl_RoleAssignment 
                SET role_id = @role 
                WHERE employee_id = @id;

                UPDATE Tbl_Employee 
                SET Counselor_Type = @type 
                WHERE Employee_Id = @id;

                -- UPDATE Tbl_User 
                -- SET role_Id = @role 
                -- WHERE user_Id = (SELECT MIN(user_Id) FROM Tbl_Employee_User WHERE Employee_Id = @id);
            END
            ELSE
            BEGIN
                INSERT INTO Tbl_RoleAssignment(User_ID, employee_id, role_id, del_Status) 
                VALUES (
                    (SELECT MIN(user_Id) FROM Tbl_Employee_User WHERE Employee_Id = @id), 
                    @id, 
                    @role, 
                    0
                );

                UPDATE Tbl_Employee 
                SET Counselor_Type = @type 
                WHERE Employee_Id = @id;
            END
        END
    ')
END
