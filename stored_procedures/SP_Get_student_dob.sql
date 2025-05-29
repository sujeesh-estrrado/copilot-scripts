IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_student_dob]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_student_dob] (      
@flag bigint=1)        
as          
begin       
 if @Flag=1              
 begin select Distinct(YEAR(Candidate_Dob)) as Year from Tbl_Candidate_Personal_Det where Candidate_Dob IS NOT NULL    
end      
end  
    ')
END;
