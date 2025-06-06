IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_OccationalTableOperations]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE PROCEDURE [dbo].[Sp_OccationalTableOperations] (
        @flag bigint,
        @OccasionalForm_FormId bigint = NULL, -- Make this parameter nullable and include it
        @OccasionalForm_FormTitle nvarchar(150) = NULL, -- Make this parameter nullable
        @OccasionalForm_FormTypeId tinyint = NULL, -- Make this parameter nullable
        @OccasionalForm_Availablity_type tinyint = NULL, -- Make this parameter nullable
        @OccasionalForm_Recurringenddate datetime = NULL, -- Make this parameter nullable
        @occasionalForm_Recurringmonth int = NULL, -- Make this parameter nullable
        @OccasionalForm_Recuringday int = NULL ,-- Make this parameter nullable
        @Question_type TINYINT = NULL,
        @Question VARCHAR(200) = NULL,
        @Options VARCHAR(1000) = NULL,
        @Upload_Type TINYINT = NULL,
        --@occationalForm_updatedDate Datetime = NULL
        @OccasionalForm_RecurringtypeOptns TINYINT =NULL 

)
AS
BEGIN
      SET NOCOUNT ON;

    -- Flag 1: Insertion
    IF (@Flag = 1)
    BEGIN
        -- Perform INSERT operation
        INSERT INTO OccasionalForms (OccasionalForm_FormTitle, OccasionalForm_FormTypeId, OccasionalForm_Availablity_type, OCassionalform_CreatedDate, OccasionalForm_StatusId, OccasionalForm_Recurringenddate, OccasionalForm_Recuringday, occasionalForm_Recurringmonth,OccasionalForm_DeleteStatus,OccasionalForm_RecurringtypeOptns)
        VALUES (@OccasionalForm_FormTitle, @OccasionalForm_FormTypeId, @OccasionalForm_Availablity_type, GETDATE(), 0, @OccasionalForm_Recurringenddate, @OccasionalForm_Recuringday, @occasionalForm_Recurringmonth,0,@OccasionalForm_RecurringtypeOptns);
         SELECT SCOPE_IDENTITY();

    END
    -- Flag 2: Deletion
     IF (@Flag = 2 AND @OccasionalForm_FormId IS NOT NULL)
    BEGIN
        -- Perform DELETE operation based on OccasionalForm_FormId
       
        update OccasionalForms set OccasionalForm_DeleteStatus=1
        where OccasionalForm_FormId = @OccasionalForm_FormId;
    END
    IF (@flag = 3)
    BEGIN
        SELECT
    OCF.OccasionalForm_FormId,
    OCF.OccasionalForm_FormTitle,
    OCF.OccasionalForm_FormTypeId,
    OCF.OccasionalForm_Availablity_type,
    CONVERT(VARCHAR, OCF.OccasionalForm_Recurringenddate, 103) AS OccasionalForm_Recurringenddate,
    OCF.OccasionalForm_Recurringmonth,
    OCF.OccasionalForm_Recuringday,
    
    -- Fields from the mapping table
    OM.Mapping_Id,
    OM.Question_type,
    OM.Question,
    OM.Options,
    OM.Upload_Type
FROM
    OccasionalForms OCF
LEFT JOIN 
    Occationalform_QuestionMapping OM
    ON OCF.OccasionalForm_FormId = OM.OccasionalForm_FormId
WHERE
    OCF.OccasionalForm_FormId = @OccasionalForm_FormId
    AND (OCF.OccasionalForm_DeleteStatus IS NULL OR OCF.OccasionalForm_DeleteStatus = 0)
    AND (OM.Delete_Status IS NULL OR OM.Delete_Status = 0)

    END

IF (@Flag = 4)
    --Edit flag

    begin
    update OccasionalForms
    set
    OccasionalForm_FormTitle=@OccasionalForm_FormTitle,
    OccasionalForm_FormTypeId=@OccasionalForm_FormTypeId,
    OccasionalForm_Availablity_type=@OccasionalForm_Availablity_type,
    OccasionalForm_Recurringenddate=@OccasionalForm_Recurringenddate,
    OccasionalForm_Recuringday=@OccasionalForm_Recuringday,
    occasionalForm_Recurringmonth=@occasionalForm_Recurringmonth,
    OccasionalForm_updatedDate=GETDATE(),
    OccasionalForm_RecurringtypeOptns=@OccasionalForm_RecurringtypeOptns

    where
        (OccasionalForm_FormId = @OccasionalForm_FormId)

    end
   

    IF @Flag = 5 AND @OccasionalForm_FormId IS NOT NULL
    BEGIN
        IF @Question_type = 1
        BEGIN
            SET @Options = NULL;
            SET @Upload_Type = NULL;
        END
        ELSE IF @Question_type = 2
        BEGIN
            SET @Upload_Type = NULL; 
        END
        ELSE IF @Question_type = 3
        BEGIN
            SET @Options = NULL; 
        END

        INSERT INTO Occationalform_QuestionMapping (
            OccasionalForm_FormId,
            Question_type,
            Question,
            Options,
            Upload_Type,
            Created_Date,
            Delete_Status
        )
        VALUES (
            @OccasionalForm_FormId,
            @Question_type,
            @Question,
            @Options,
            @Upload_Type,
            GETDATE(),
            0
        );
    END

     --SELECT SCOPE_IDENTITY();


END
   ')
END;
