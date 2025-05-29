IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Candidate_Scholarship_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_Candidate_Scholarship_Details]   
(   
@flag bigint=0,             
@Candidate_Id bigint=0,              
@Scholarship_Name varchar(MAX)='''',              
@Scholarship_Remarks varchar(MAX)=''''
)     
AS              

BEGIN      
if(@flag=1)     
begin   
if not exists (select * from Tbl_Scholarship_Details where Scholarship_Name=@Scholarship_Name and Candidate_Id=@Candidate_Id and Scholarship_Del_Status=0)
begin        
Insert Into Tbl_Scholarship_Details(Candidate_Id,Scholarship_Name,Scholarship_Remarks,Created_Date,Scholarship_Del_Status) 
values(@Candidate_Id,@Scholarship_Name,@Scholarship_Remarks,getdate(),0)            
 end   
 end
  
  if(@flag=2)--get 
	begin

	select Candidate_Id,Scholarship_Name,Scholarship_Remarks from Tbl_Scholarship_Details 
	where (Candidate_Id= @Candidate_Id) and Scholarship_Del_Status=0 ;
	end
	if(@flag=3)
	begin

	delete Tbl_Scholarship_Details where Candidate_Id= @Candidate_Id;

	end    
	
End         ');
END;
