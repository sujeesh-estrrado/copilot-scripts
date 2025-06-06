IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_ReviewDetails_for_JobDiary]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_SP_Get_ReviewDetails_for_JobDiary] -- 446    
 -- Add the parameters for the stored procedure here      
 @User_Id bigint   
AS      
BEGIN      
select R.Review_Id,R.Review_Date,R.JobDiary_Date,R.Remark,E.Employee_FName+'' ''+E.Employee_LName as Emp_Name from LMS_Tbl_ReviewJobDiary R
inner join Tbl_Employee E on R.Reviewed_By=E.Employee_Id  
where E.Employee_Status=0 and R.Status=0 and R.Reviewed_On=@User_Id  
END
    ')
END
