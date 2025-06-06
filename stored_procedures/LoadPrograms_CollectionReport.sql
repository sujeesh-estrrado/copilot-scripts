IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LoadPrograms_CollectionReport]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
create PROCEDURE [dbo].[LoadPrograms_CollectionReport]


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

SELECT distinct st.courseid,  D.Department_Name,D.Department_Id DeptId
--,IM.intake_month
from student_transaction st left join
Tbl_Department D  on st.courseid=D.Department_Id


 --FROM Tbl_Department D 
 --left join student_transaction st on D.Department_Id=st.courseid


 
END
    ')
END;
