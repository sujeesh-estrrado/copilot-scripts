IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_Messages]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_SP_Get_Messages] -- 446    
 -- Add the parameters for the stored procedure here      
 @User_Id bigint   
AS      
BEGIN      
select SM.Stu_Par_Send_Message,SM.Reply_Teacher_Message,E.Employee_FName+'' ''+E.Employee_LName as Emp_Name, 
SM.Created_Date  from  LMS_Tbl_SendAndReceive_Message_Mapping SM
inner join LMS_Tbl_Send_Message_From_StudentAndParent S on SM.Stu_Par_Mapping_Id=S.St_Par_Id
inner join Tbl_Employee E on SM.Teacher_Id=E.Employee_Id  
where SM.Status=0 and E.Employee_Status=0 and S.Student_Parent_Id=@User_Id
END
    ')
END
