IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SelectFeeCollection]') 
    AND type = N'P'
)
BEGIN
    EXEC('
     
CREATE procedure [dbo].[SelectFeeCollection]  -- 112,18--6,1--891,11820 --809,11829  --461,11830       --157,11830--265,11850                                    
( @CandidateId bigint,@intake bigint  )                                           
as                                              
begin                                              
declare @Cnt bigint;                                              
set @Cnt=(select count(Fee_Entry_Id) from Tbl_Fee_Entry_Main where Candidate_Id=@CandidateId and IntakeId=@intake)                                              
if (@Cnt>0)                                              
begin                           
select a.*                      
,(select Miscellaneous_due_date FROM Tbl_Fee_Entry_Main WHERE Candidate_Id=@CandidateId AND                       
IntakeId=@intake  AND TYP=a.Typ AND FeeHeadId=a.FeeHead_Id and ItemDescription=a.ItemDescription and ActiveStatus<>'''') as Miscellaneous_due_date                      
 FROM(                                         
select Candidate_Id,IntakeId Intake_Id,FeeHeadId Feehead_Id,Amount,                             
--Miscellaneous_due_date,                                            
(select Fee_Head_Name  from dbo.Tbl_Fee_Head where Fee_Head_Id=FM.FeeHeadId)as FeeHeadName ,Currency,typ,ItemDescription,Balance, isnull(Paid,0)as Paid,''0'' pay                                    
,'''' as FeeCode  --(select Feecode from dbo.Tbl_FeecodeStudentMap where Candidate_Id=@CandidateId and Intake_Id=@intake)as FeeCode                                    
,(select distinct Course_Id from dbo.Tbl_FeecodeStudentMap where Candidate_Id=@CandidateId and Intake_Id=@intake)as CourseId                                    
from Tbl_Fee_Entry_Main FM where FM.Candidate_Id=@CandidateId and FM.IntakeId=@intake  --- is NULL                    
                      
--                      
--UNION                      
--select fc.Candidate_Id,fc.Intake_Id ,fd.Feehead_Id,fd.Amount,                            
----FM.Miscellaneous_due_date,                             
--fh1.Fee_Head_Name FeeHeadName,fd.Currency,                                        
--''Normal'' typ,fd.ItemDescription,fd.Amount Balance,                                        
--''0'' Paid,''0'' pay,FC.Feecode,FC.Course_Id                                      
--from TBL_FeeSettingsDetails FD                                               
--inner join Tbl_Fee_Settings F on f.Fee_Settings_Id=FD.Fee_Settings_Id                                        
--inner join Tbl_Fee_Head fh1 on fh1.Fee_Head_Id=fd.Feehead_Id                              
--INNER JOIN  dbo.Tbl_Fee_Entry_Main FM ON FM.FeeHeadId=FD.Feehead_Id AND FM.Candidate_Id=@CandidateId --Commented                      
--                                             
--inner join Tbl_FeecodeStudentMap FC on fc.Feecode=f.Scheme_Code  where fc.Candidate_Id=@CandidateId and fc.Intake_Id=@intake                                       
--and fd.Feehead_Id not in ( select FeeHeadId from Tbl_Fee_Entry_Main FM where FM.Candidate_Id=@CandidateId and FM.IntakeId=@intake and FM.ItemDescription=fd.ItemDescription)                                        
--                                              
--                                            
--union                                         
--select FCM.Candidate_Id,FCM.Intake_Id,fcomd.FeeHeadId Feehead_Id,fcomd.Amount,                            
----FM.Miscellaneous_due_date,                            
--fh2.Fee_Head_Name FeeHeadName,fcomd.CurrencyId Currency,''Compulsory'' typ,fcomd.ItemDescription, fcomd.Amount Balance,''0'' Paid,''0'' pay                                    
--,'''' as FeeCode --(select Feecode from dbo.Tbl_FeecodeStudentMap where Candidate_Id=@CandidateId and Intake_Id=@intake) as FeeCode                                     
--,FCM.Course_Id                                      
--from Tbl_Fee_Compulsory fcom                                              
-- inner join Tbl_Fee_CompulsoryDetails fcomd on fcom.CompulsoryFeeId=fcomd.CumpulsoryFeeId            
-- inner join Tbl_Fee_Head fh2 on fh2.Fee_Head_Id=fcomd.FeeHeadId                              
-- INNER JOIN  dbo.Tbl_Fee_Entry_Main FM ON FM.FeeHeadId=fh2.Fee_Head_Id  AND FM.Candidate_Id=@CandidateId  --Commented                               
-- inner join Tbl_FeecodeStudentMap FCM on FCM.Course_Id=fcom.CourseId where  FCM.Candidate_Id=@CandidateId and FCM.Intake_Id=@intake and  fcom.TypeOfStudent=(select TypeOfStudent from Tbl_Candidate_Personal_Det cp where cp.Candidate_Id=@CandidateId)     
 
     
     
         
          
              
--                    
--and fcomd.FeeHeadId not in ( select FM.FeeHeadId from Tbl_Fee_Entry_Main FM where FM.Candidate_Id=@CandidateId and FM.IntakeId=@intake and FM.ItemDescription=fcomd.ItemDescription)                                        
--               
 )a                                             
end                        
                      
                         
                      
else                                             
begin                                              
select a.*                      
,(select Miscellaneous_due_date FROM Tbl_Fee_Entry_Main WHERE Candidate_Id=@CandidateId AND                       
IntakeId=@intake  AND TYP=a.Typ AND FeeHeadId=a.FeeHead_Id and ItemDescription=a.ItemDescription ) as Miscellaneous_due_date                      
                      
 from(select fc.Candidate_Id,fc.Intake_Id ,fd.Feehead_Id,fd.Amount,                            
--FM.Miscellaneous_due_date,                            
fh1.Fee_Head_Name FeeHeadName,fd.Currency,                                        
''Normal'' typ,fd.ItemDescription,fd.Amount Balance,                                        
''0'' Paid,''0'' pay,                                    
--(select Feecode from dbo.Tbl_FeecodeStudentMap where Candidate_Id=@CandidateId and Intake_Id=@intake)as FeeCode             
'''' as FeeCode                                    
,(select Distinct Course_Id from dbo.Tbl_FeecodeStudentMap where Candidate_Id=@CandidateId and Intake_Id=@intake)as CourseId                                    
  from TBL_FeeSettingsDetails FD                                               
inner join Tbl_Fee_Settings F on f.Fee_Settings_Id=FD.Fee_Settings_Id                                        
inner join Tbl_Fee_Head fh1 on fh1.Fee_Head_Id=fd.Feehead_Id                              
--INNER JOIN  dbo.Tbl_Fee_Entry_Main FM ON FM.FeeHeadId=fh1.Fee_Head_Id AND FM.Candidate_Id=@CandidateId                                              
inner join Tbl_FeecodeStudentMap FC on fc.Feecode=f.Scheme_Code  where fc.Candidate_Id=@CandidateId and fc.Intake_Id=@intake AND fd.Amount<>0                                              
union                            
                            
                                          
select FCM.Candidate_Id,FCM.Intake_Id,fcomd.FeeHeadId Feehead_Id,fcomd.Amount,                            
--FM.Miscellaneous_due_date,                            
fh2.Fee_Head_Name FeeHeadName,fcomd.CurrencyId Currency,''Compulsory'' typ,fcomd.ItemDescription, fcomd.Amount Balance,''0'' Paid,''0'' pay,                                     
FCM.Feecode,FCM.Course_Id from Tbl_Fee_Compulsory fcom                                              
 inner join Tbl_Fee_CompulsoryDetails fcomd on fcom.CompulsoryFeeId=fcomd.CumpulsoryFeeId                                        
 inner join Tbl_Fee_Head fh2 on fh2.Fee_Head_Id=fcomd.FeeHeadId                                   
 --INNER JOIN  dbo.Tbl_Fee_Entry_Main FM ON FM.FeeHeadId=fh2.Fee_Head_Id  AND FM.Candidate_Id=@CandidateId                                  
 inner join Tbl_FeecodeStudentMap FCM on FCM.Course_Id=fcom.CourseId where  FCM.Candidate_Id=@CandidateId and FCM.Intake_Id=@intake and  fcom.TypeOfStudent=(select TypeOfStudent from Tbl_Candidate_Personal_Det cp where cp.Candidate_Id=@CandidateId)       
  
    
      
        
          
            
              
               
                   
                    
          
 )a                        
                                   
                                     
 end             
                                               
                                              
end
   ')
END;
