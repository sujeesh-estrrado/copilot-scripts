IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_PermanentFormAddEmployee]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_PermanentFormAddEmployee]
    @allemp BIGINT,
    @Permanent_FormId BIGINT,
    @SelectedDepartmentid VARCHAR(150),
    @SelectedRoleid VARCHAR(150),
    @SelectedEmployeeid VARCHAR(150)
AS
BEGIN
    -- Insert into tbl_PermanentFormEmployee
    INSERT INTO tbl_PermanentFormEmployee (
        Permanent_FormId,
        AllEmployee,
        Department_Id,
        Role_Id,
        CreatedDate,
        DelStatus,
        SelectedEmp_Id
    )
    VALUES (
        @Permanent_FormId,
        @allemp,
        @SelectedDepartmentid,
        @SelectedRoleid,
        GETDATE(),
        0,
        @SelectedEmployeeid
    );

    
END
   ')
END;
