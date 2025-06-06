IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_ReviewStatus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_SP_Get_ReviewStatus] --299,446       
 -- Add the parameters for the stored procedure here            
 @User_Id bigint ,    
@Student_Id bigint   ,
@Date datetime     
AS            
BEGIN            
select R.Review_Date,R.JobDiary_Date,R.Remark,E.Employee_FName+'' ''+E.Employee_LName as Emp_Name,case R.Status when 0 then ''Waiting'' else ''Notified'' end as Status from LMS_Tbl_ReviewJobDiary R      
inner join Tbl_Employee E on R.Reviewed_By=E.Employee_Id        
where E.Employee_Status=0  and R.Reviewed_On=@Student_Id and  R.Reviewed_By=@User_Id  and R.JobDiary_Date=@Date    
END
    ')
END
