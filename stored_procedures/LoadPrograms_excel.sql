IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LoadPrograms_excel]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        create PROCEDURE [dbo].[LoadPrograms_excel]


AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
--SELECT   concat(D.Department_Id,''#'',CBD.Batch_Id) Department_Id,D.Department_Name,D.Department_Id DeptId
----,IM.intake_month

-- FROM Tbl_IntakeMaster IM
-- left join Tbl_Course_Batch_Duration CBD ON CBD.IntakeMasterID = IM.id
-- left join Tbl_Department D on D.Department_Id=  CBD.Duration_Id

--SELECT   concat(D.Department_Id,''#'',CBD.Batch_Id) Department_Id,D.Department_Name,D.Department_Id DeptId
----,IM.intake_month

-- FROM Tbl_Course_Batch_Duration CBD left join Tbl_Department D on cbd.Duration_Id=D.Department_Id


 select Department_Name from Tbl_Department

 
END
    ')
END;
