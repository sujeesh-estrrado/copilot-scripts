-- Check if the procedure exists before creating it
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SelectFeeCollection_sreelal_test]') 
    AND type = N'P'
)
BEGIN
    EXEC('
            
CREATE procedure [dbo].[SelectFeeCollection_sreelal_test] --809,11829  --461,11830       --157,11830--265,11850                          
( @CandidateId bigint,@intake bigint  )                                 
as                                    
begin  
  
  
if OBJECT_ID(''tempdb..##GreaterCount'') is  null  
Begin  
Create table ##GreaterCount(Candidate_Id bigint,Intake_Id bigint,Feehead_Id Bigint,Amount Bigint,FeeHeadName varchar(100),Currency Bigint,typ varchar(100),ItemDescription varchar(200),Balance bigint,Paid Decimal(18,2),pay bigint,FeeCode varchar(200),CourseId bigint,Miscellaneous_due_date varchar(100))   
END    
ELSe  
  Begin  
drop table ##GreaterCount  
END    
Create table #FeeCode (FeeCode_Id int IDENTITY(1,1) PRIMARY KEY,FeeCode varchar(100))  
Create table #GreaterCountss(Candidate_Id bigint,Intake_Id bigint,Feehead_Id Bigint,Amount Bigint,FeeHeadName varchar(100),Currency Bigint,typ varchar(100),ItemDescription varchar(200),Balance bigint,Paid Decimal(18,2),pay bigint,FeeCode varchar(200),CourseId bigint,Miscellaneous_due_date varchar(100))   
Create table #LesserCount(Candidate_Id bigint,Intake_Id bigint,Feehead_Id Bigint,Amount Bigint,FeeHeadName varchar(100),Currency Bigint,typ varchar(100),ItemDescription varchar(200),Balance bigint,Paid Decimal(18,2),pay bigint,FeeCode varchar(200),CourseId bigint,Miscellaneous_due_date varchar(100))                                
                               
declare @Cnt bigint;   
declare @FeeCode varchar(100)   
Declare @LoopCount Int   
declare @FeeCodeCount int    
set @LoopCount=1   
set @FeeCodeCount= (select count(Feecode) from dbo.Tbl_FeecodeStudentMap where Candidate_Id=@CandidateId and Intake_Id=@intake)                                   
set @Cnt=(select count(Fee_Entry_Id) from Tbl_Fee_Entry_Main where Candidate_Id=@CandidateId and IntakeId=@intake)  
-- To get All Fee Code  
insert into #FeeCode (FeeCode)select Feecode from dbo.Tbl_FeecodeStudentMap where Candidate_Id=@CandidateId and Intake_Id=@intake                                    
if (@Cnt>0)   
begin   
 While(@LoopCount<=@FeeCodeCount)  
  Begin  
  set @FeeCode =(select T.FeeCode from #FeeCode as T where T.FeeCode_Id=@LoopCount)  
  
  
  --------------------------------------------------------------------------Begin Old Code  
  
  insert into ##GreaterCount(Candidate_Id,Intake_Id,Feehead_Id,Amount,FeeHeadName,Currency,typ,ItemDescription,Balance,Paid,pay,FeeCode,CourseId,Miscellaneous_due_date)   
  select a.*            
  ,(select Miscellaneous_due_date FROM Tbl_Fee_Entry_Main WHERE Candidate_Id=@CandidateId AND             
  IntakeId=@intake  AND TYP=a.Typ AND FeeHeadId=a.FeeHead_Id and ItemDescription=a.ItemDescription and ActiveStatus<>'''') as Miscellaneous_due_date            
  FROM(                               
  select Candidate_Id,IntakeId Intake_Id,FeeHeadId Feehead_Id,Amount,                   
  (select Fee_Head_Name  from dbo.Tbl_Fee_Head where Fee_Head_Id=FM.FeeHeadId)as FeeHeadName ,Currency,typ,ItemDescription,Balance, isnull(Paid,0)as Paid,''0'' pay                          
  ,@FeeCode as FeeCode---,(select Feecode from dbo.Tbl_FeecodeStudentMap where Candidate_Id=@CandidateId and Intake_Id=@intake)as FeeCode    -- Old Code Multiple Entries                          
  ,(select distinct Course_Id from dbo.Tbl_FeecodeStudentMap where Candidate_Id=@CandidateId and Intake_Id=@intake)as CourseId                          
  from Tbl_Fee_Entry_Main FM where FM.Candidate_Id=@CandidateId and FM.IntakeId=@intake AND FM.ActiveStatus  IS NULL     
         
                   
  UNION            
  select fc.Candidate_Id,fc.Intake_Id ,fd.Feehead_Id,fd.Amount,                  
  fh1.Fee_Head_Name FeeHeadName,fd.Currency,                              
  ''Normal'' typ,fd.ItemDescription,fd.Amount Balance,                              
  ''0'' Paid,''0'' pay,FC.Feecode,FC.Course_Id                            
  from TBL_FeeSettingsDetails FD                                     
  inner join Tbl_Fee_Settings F on f.Fee_Settings_Id=FD.Fee_Settings_Id                              
  inner join Tbl_Fee_Head fh1 on fh1.Fee_Head_Id=fd.Feehead_Id                    
                                   
  inner join Tbl_FeecodeStudentMap FC on @FeeCode=f.Scheme_Code  where fc.Candidate_Id=@CandidateId and fc.Intake_Id=@intake                             
  and fd.Feehead_Id not in ( select FeeHeadId from Tbl_Fee_Entry_Main FM where FM.Candidate_Id=@CandidateId and FM.IntakeId=@intake and FM.ItemDescription=fd.ItemDescription)                              
                                    
                                  
  union                               
  select FCM.Candidate_Id,FCM.Intake_Id,fcomd.FeeHeadId Feehead_Id,fcomd.Amount,                  
  fh2.Fee_Head_Name FeeHeadName,fcomd.CurrencyId Currency,''Compulsory'' typ,fcomd.ItemDescription, fcomd.Amount Balance,''0'' Paid,''0'' pay                          
  ,@FeeCode as FeeCode --,(select Feecode from dbo.Tbl_FeecodeStudentMap where Candidate_Id=@CandidateId and Intake_Id=@intake) as FeeCode                           
  ,FCM.Course_Id                            
  from Tbl_Fee_Compulsory fcom                                    
  inner join Tbl_Fee_CompulsoryDetails fcomd on fcom.CompulsoryFeeId=fcomd.CumpulsoryFeeId                              
  inner join Tbl_Fee_Head fh2 on fh2.Fee_Head_Id=fcomd.FeeHeadId                    
  inner join Tbl_FeecodeStudentMap FCM on FCM.Course_Id=fcom.CourseId where  FCM.Candidate_Id=@CandidateId and FCM.Intake_Id=@intake and  fcom.TypeOfStudent=(select TypeOfStudent from Tbl_Candidate_Personal_Det cp where cp.Candidate_Id=@CandidateId)      
   
         
  and fcomd.FeeHeadId not in ( select FM.FeeHeadId from Tbl_Fee_Entry_Main FM where FM.Candidate_Id=@CandidateId and FM.IntakeId=@intake and FM.ItemDescription=fcomd.ItemDescription)                              
  )a                                   
                
  set @LoopCount=@LoopCount+1  
 end  
  --select distinct * into #GreaterCountss from #GreaterCount  
select distinct * from ##GreaterCount  
End  
else                                   
begin   
 While(@LoopCount<=@FeeCodeCount)  
  BEGIN  
  set @FeeCode =(select T.FeeCode from #FeeCode as T where T.FeeCode_Id=@LoopCount)  
  ---------------------------------------------------------------------Old Else Code  
  insert into #LesserCount(Candidate_Id,Intake_Id,Feehead_Id,Amount,FeeHeadName,Currency,typ,ItemDescription,Balance,Paid,pay,FeeCode,CourseId,Miscellaneous_due_date)   
  
  select a.*            
  ,(select Miscellaneous_due_date FROM Tbl_Fee_Entry_Main WHERE Candidate_Id=@CandidateId AND             
  IntakeId=@intake  AND TYP=a.Typ AND FeeHeadId=a.FeeHead_Id and ItemDescription=a.ItemDescription ) as Miscellaneous_due_date            
            
  from(select fc.Candidate_Id,fc.Intake_Id ,fd.Feehead_Id,fd.Amount,                  
  --FM.Miscellaneous_due_date,                  
  fh1.Fee_Head_Name FeeHeadName,fd.Currency,                              
  ''Normal'' typ,fd.ItemDescription,fd.Amount Balance,                              
  ''0'' Paid,''0'' pay,                          
  @FeeCode as FeeCode--(select Feecode from dbo.Tbl_FeecodeStudentMap where Candidate_Id=@CandidateId and Intake_Id=@intake)as FeeCode                          
  ,(select Course_Id from dbo.Tbl_FeecodeStudentMap where Candidate_Id=@CandidateId and Intake_Id=@intake)as CourseId                          
  from TBL_FeeSettingsDetails FD                                     
  inner join Tbl_Fee_Settings F on f.Fee_Settings_Id=FD.Fee_Settings_Id                              
  inner join Tbl_Fee_Head fh1 on fh1.Fee_Head_Id=fd.Feehead_Id                    
  --INNER JOIN  dbo.Tbl_Fee_Entry_Main FM ON FM.FeeHeadId=fh1.Fee_Head_Id AND FM.Candidate_Id=@CandidateId                                    
  inner join Tbl_FeecodeStudentMap FC on @FeeCode=f.Scheme_Code  where fc.Candidate_Id=@CandidateId and fc.Intake_Id=@intake                                     
   
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
  ----------------------------------------------------------------------END  
  set @LoopCount=@LoopCount+1  
  END     
 SELECT * FROM #LesserCount                                                           
 end           
                           
 end


    ')
END;
GO
