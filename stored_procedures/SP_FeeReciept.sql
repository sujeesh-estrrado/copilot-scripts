IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_FeeReciept]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[SP_FeeReciept] --300             
(@FeeEntryIds  nvarchar(max))                    
as                    
begin                    
declare @CleanString varchar(Max)                    
    SET @CleanString=(Replace(@FeeEntryIds,'''''''',''''))                    
                    
select distinct FE.Fee_Entry_Id,      
case FE.CollectedBy when '''' then ''Admin''      
when ''NULL'' then ''Admin''      
else FE.CollectedBy end as CollectedBy, D.Course_Code+''-''+CBD.Batch_Code as CourseName,        
      
 FE.*,CBD.Batch_Code,D.Course_Code,FH.Fee_Head_Name,AdharNumber as IC,             
case FE.typ when ''MISC''              
then                    
FH.Fee_Head_Name+''-''+Convert(varchar(10),getdate(),103)+''-''+ CONVERT(VARCHAR(8), GETDATE(), 108)              
when ''Normal''              
then              
  FH.Fee_Head_Name+''-''+D.Course_Code+''-''+CBD.Batch_Code+''-''+CBD.Study_Mode              
  when ''Compulsory''              
  then              
  FH.Fee_Head_Name+''-''+D.Course_Code+''-''+CBD.Batch_Code+''-''+CBD.Study_Mode              
  end as ItemDescription,              
                  
                    
--case PD.Payment_Details_Mode                    
--                    
--when ''1'' then''CASH''                
--when ''2'' then ''CHEQUE''                
--when ''3'' then ''CREDIT CARD''                
--WHEN ''4'' THEN ''EMGS''                
--when ''5'' then ''PTPTN Direct Debit''                
--when ''6'' then ''SALARY DEDUCTION''                
--when ''7'' then ''TELEGRAPHIC TRANSFER''            
--when ''8'' then ''TRANSFERRED''                    
--end as MOP,          
fe.MOP,                    
CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname as CandidateName                    
                    
                    
                    
 from Tbl_Fee_Entry FE                    
inner join  Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=FE.IntakeId                    
left join dbo.Tbl_Student_Registration SR on SR.Candidate_Id=FE.Candidate_Id                    
left join dbo.Tbl_Department D on D.Department_Id=SR.Department_Id                    
inner join dbo.Tbl_Fee_Head FH on FH.Fee_Head_Id=FE.FeeHeadId                    
inner join dbo.Tbl_Fee_Entry_Details FD on FD.Fee_Entry_Details_Id=FE.Feeid                    
inner join dbo.Tbl_Payment_Details PD on PD.Payment_Details_Particulars_Id=FE.Feeid                    
inner join dbo.Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=FE.Candidate_Id                    
                    
where FE.Fee_Entry_Id in (select item from SplitString (@FeeEntryIds,'',''))                    
end 
    ')
END
