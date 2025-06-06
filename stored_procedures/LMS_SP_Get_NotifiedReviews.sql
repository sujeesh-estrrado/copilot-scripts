IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_NotifiedReviews]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_SP_Get_NotifiedReviews] --446,''2017/02/09''   
 -- Add the parameters for the stored procedure here            
@User_Id bigint ,    
@Date datetime  
AS            
BEGIN            
select R.Review_Date,R.JobDiary_Date,R.Remark,E.Employee_FName+'' ''+E.Employee_LName as Emp_Name,case R.Status when 0 then ''Waiting'' else ''Notified'' end as Status from LMS_Tbl_ReviewJobDiary R      
inner join Tbl_Employee E on R.Reviewed_By=E.Employee_Id        
where E.Employee_Status=0  and R.Reviewed_On=@User_Id and  R.JobDiary_Date=@Date      
END

    ')
END
