IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LoadPrograms_NewEnquiry]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LoadPrograms_NewEnquiry]


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

SELECT   concat(D.Department_Id,''#'',CBD.Batch_Id) Department_Id,D.Department_Name,D.Department_Id DeptId
--,IM.intake_month

 FROM Tbl_Course_Batch_Duration CBD left join Tbl_Department D on cbd.Duration_Id=D.Department_Id
  --Select distinct Department_Id,Department_Name,GraduationTypeId,Department_Id DeptId from Tbl_Department            
  --where  Department_Status=0 and Active_Status=''Active'' and Delete_Status=0     --and Online_checkstatus=1        
  --order by Department_Name  

 
END
    ')
END;
