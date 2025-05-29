IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Update_Candidate_ExtraRemarks]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE  procedure [dbo].[Update_Candidate_ExtraRemarks]     
(    
@ExtraRemarks varchar(Max)='''',    
@Candidate_Id bigint=0,    
@flag bigint=0    
)    
as      
begin      
if(@flag=0)    
begin    
 Update  Tbl_Candidate_Personal_Det set ExtraRemarks=@ExtraRemarks,Scolorship_Remark=    @ExtraRemarks
 where Candidate_Id=@Candidate_Id    
end    
if(@flag=1)    
begin    
 select  ExtraRemarks from Tbl_Candidate_Personal_Det    
 where Candidate_Id=@Candidate_Id    
end    
if(@flag=2)    
begin    
 Update  Tbl_Lead_Personal_Det set ExtraRemarks=@ExtraRemarks,Scolorship_Remark=    @ExtraRemarks
 where Candidate_Id=@Candidate_Id    
end    
if(@flag=3)    
begin    
 select  ExtraRemarks from Tbl_Lead_Personal_Det    
 where Candidate_Id=@Candidate_Id    
end    
end 

    ')
END;
