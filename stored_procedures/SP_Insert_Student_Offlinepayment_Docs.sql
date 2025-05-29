IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Student_Offlinepayment_Docs]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_Student_Offlinepayment_Docs] -- 2  
 (
 @Candidate_Id bigint ,
 @Document_Path varchar(MAX),
 @Amount decimal,
 @Date varchar(MAX),
 @Remarks varchar(MAX)
 )   
AS    
BEGIN    
insert into Tbl_Candidate_Offlinepay_Doc    
(Candidate_Id,Document_Path,Amount,Date,Remarks,Created_Date,Delete_status)
values(@Candidate_Id,@Document_Path,@Amount,@Date,@Remarks,getdate(),0)   
END

--select * from Tbl_Candidate_Offlinepay_Doc
    ')
END;
