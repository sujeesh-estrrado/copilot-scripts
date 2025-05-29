IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_Candidate_Family_Salary_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Insert_Candidate_Family_Salary_Details] --2,10065,''~/StudentDocs/Student Invoice (5).pdf'',''dccf''
(
@flag bigint=0,
@Candidate_Id bigint,
@ResultAttachment   varchar(MAX)='''',
@Remarks    varchar(MAX)='''',
@SlNo Bigint=0
)  
as  
begin   
    
    if(@flag=1)
    begin
        select * from Tbl_Candidate_Family_SalaryDetails where Candidate_Id=@Candidate_Id and  Delete_Status=0
    end
    else if(@flag=2)
    begin
        Update Tbl_Candidate_Family_SalaryDetails set Delete_Status=1 where Candidate_Id=@Candidate_Id and Delete_Status=0
    end
    else if not exists(select * from Tbl_Candidate_Family_SalaryDetails where ResultAttachment=@ResultAttachment and Candidate_Id=@Candidate_Id  and Delete_Status=0)
    begin
        insert into Tbl_Candidate_Family_SalaryDetails(Candidate_Id,ResultAttachment,Remarks,SlNo,created_Date,Delete_Status)
         values(@Candidate_Id,@ResultAttachment,@Remarks,@SlNo,getdate(),0) 
    end
    else
    begin
         Update Tbl_Candidate_Family_SalaryDetails set ResultAttachment=@ResultAttachment, Remarks=@Remarks
         where Candidate_Id=@Candidate_Id and ResultAttachment=@ResultAttachment and Remarks=@Remarks
    end

end

   ')
END;
