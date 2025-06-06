IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SelectStudent_ByIntake_NEW]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       
 CREATE procedure [dbo].[Proc_SelectStudent_ByIntake_NEW] --10
(@IntakeId bigint)                      
as                      
begin               
select A.* from                      
  (select distinct(c.Candidate_Id),c.Candidate_Fname+'' ''+ c.Candidate_Mname+'' ''+c.Candidate_Lname CandidateName,                
c.AdharNumber,            
            
(select sum(T1.Amount) as Totaltobepaid from 

(select Candidate_Id,IntakeId Intake_Id,FeeHeadId Feehead_Id,Amount,                   
(select Fee_Head_Name  from dbo.Tbl_Fee_Head where Fee_Head_Id=FM.FeeHeadId)as FeeHeadName ,Currency,typ,ItemDescription,Balance, Paid ,''0'' pay from Tbl_Fee_Entry_Main FM 
where FM.Candidate_Id=C.Candidate_Id and FM.IntakeId=@IntakeId              
union all              
select fc.Candidate_Id,fc.Intake_Id ,fd.Feehead_Id,fd.Amount,fh1.Fee_Head_Name FeeHeadName,fd.Currency,                
''Normal'' typ,fd.ItemDescription,fd.Amount Balance,                
''0'' Paid,''0'' pay  from TBL_FeeSettingsDetails FD                       
inner join Tbl_Fee_Settings F on f.Fee_Settings_Id=FD.Fee_Settings_Id                
inner join Tbl_Fee_Head fh1 on fh1.Fee_Head_Id=fd.Feehead_Id                       
inner join Tbl_FeecodeStudentMap FC on fc.Feecode=f.Scheme_Code  where fc.Candidate_Id=C.Candidate_Id and fc.Intake_Id=@IntakeId               
and fd.Feehead_Id not in ( select FeeHeadId from Tbl_Fee_Entry_Main FM where FM.Candidate_Id=C.Candidate_Id and FM.IntakeId=@IntakeId and FM.ItemDescription=fd.ItemDescription)                
                      
                    
union all                     
select FCM.Candidate_Id,FCM.Intake_Id,fcomd.FeeHeadId Feehead_Id,fcomd.Amount,fh2.Fee_Head_Name FeeHeadName,fcomd.CurrencyId Currency,''Compulsory'' typ,fcomd.ItemDescription, fcomd.Amount Balance,''0'' Paid,''0'' pay from Tbl_Fee_Compulsory fcom               

      
 inner join Tbl_Fee_CompulsoryDetails fcomd on fcom.CompulsoryFeeId=fcomd.CumpulsoryFeeId                
 inner join Tbl_Fee_Head fh2 on fh2.Fee_Head_Id=fcomd.FeeHeadId                  
 inner join Tbl_FeecodeStudentMap FCM on FCM.Course_Id=fcom.CourseId where  FCM.Candidate_Id=C.Candidate_Id and FCM.Intake_Id=@IntakeId and  fcom.TypeOfStudent=(select TypeOfStudent from Tbl_Candidate_Personal_Det cp where cp.Candidate_Id=C.Candidate_Id) 

   
and fcomd.FeeHeadId not in ( select FM.FeeHeadId from Tbl_Fee_Entry_Main FM where FM.Candidate_Id=C.Candidate_Id and FM.IntakeId=@IntakeId and FM.ItemDescription=fcomd.ItemDescription))T1) as TotalAmountobepaid,            
            
(select sum(T1.Paid) as TotalPaid from (select Candidate_Id,IntakeId Intake_Id,FeeHeadId Feehead_Id,Amount,                   
(select Fee_Head_Name  from dbo.Tbl_Fee_Head where Fee_Head_Id=FM.FeeHeadId)as FeeHeadName ,Currency,typ,ItemDescription,Balance, Paid ,''0'' pay from Tbl_Fee_Entry_Main FM where FM.Candidate_Id=C.Candidate_Id and FM.IntakeId=@IntakeId              
union all              
select fc.Candidate_Id,fc.Intake_Id ,fd.Feehead_Id,fd.Amount,fh1.Fee_Head_Name FeeHeadName,fd.Currency,                
''Normal'' typ,fd.ItemDescription,fd.Amount Balance,                
''0'' Paid,''0'' pay  from TBL_FeeSettingsDetails FD                       
inner join Tbl_Fee_Settings F on f.Fee_Settings_Id=FD.Fee_Settings_Id                
inner join Tbl_Fee_Head fh1 on fh1.Fee_Head_Id=fd.Feehead_Id                       
inner join Tbl_FeecodeStudentMap FC on fc.Feecode=f.Scheme_Code  where fc.Candidate_Id=C.Candidate_Id and fc.Intake_Id=@IntakeId               
and fd.Feehead_Id not in ( select FeeHeadId from Tbl_Fee_Entry_Main FM where FM.Candidate_Id=C.Candidate_Id and FM.IntakeId=@IntakeId and FM.ItemDescription=fd.ItemDescription)                
                      
                    
union all                     
select FCM.Candidate_Id,FCM.Intake_Id,fcomd.FeeHeadId Feehead_Id,fcomd.Amount,fh2.Fee_Head_Name FeeHeadName,fcomd.CurrencyId Currency,''Compulsory'' typ,fcomd.ItemDescription, fcomd.Amount Balance,''0'' Paid,''0'' pay from Tbl_Fee_Compulsory fcom               

           
 inner join Tbl_Fee_CompulsoryDetails fcomd on fcom.CompulsoryFeeId=fcomd.CumpulsoryFeeId        
 inner join Tbl_Fee_Head fh2 on fh2.Fee_Head_Id=fcomd.FeeHeadId                  
 inner join Tbl_FeecodeStudentMap FCM on FCM.Course_Id=fcom.CourseId where  FCM.Candidate_Id=C.Candidate_Id and FCM.Intake_Id=@IntakeId and  fcom.TypeOfStudent=(select TypeOfStudent from Tbl_Candidate_Personal_Det cp where cp.Candidate_Id=C.Candidate_Id) 


             
and fcomd.FeeHeadId not in ( select FM.FeeHeadId from Tbl_Fee_Entry_Main FM where FM.Candidate_Id=C.Candidate_Id and FM.IntakeId=@IntakeId and FM.ItemDescription=fcomd.ItemDescription))T1) as totalpaid,            
            
(select sum(T1.Balance) as Balance from (select Candidate_Id,IntakeId Intake_Id,FeeHeadId Feehead_Id,Amount,                   
(select Fee_Head_Name  from dbo.Tbl_Fee_Head where Fee_Head_Id=FM.FeeHeadId)as FeeHeadName ,Currency,typ,ItemDescription,Balance, Paid ,''0'' pay from Tbl_Fee_Entry_Main FM where FM.Candidate_Id=C.Candidate_Id and FM.IntakeId=@IntakeId              
union all              
select fc.Candidate_Id,fc.Intake_Id ,fd.Feehead_Id,fd.Amount,fh1.Fee_Head_Name FeeHeadName,fd.Currency,                
''Normal'' typ,fd.ItemDescription,fd.Amount Balance,                
''0'' Paid,''0'' pay  from TBL_FeeSettingsDetails FD                       
inner join Tbl_Fee_Settings F on f.Fee_Settings_Id=FD.Fee_Settings_Id                
inner join Tbl_Fee_Head fh1 on fh1.Fee_Head_Id=fd.Feehead_Id                       
inner join Tbl_FeecodeStudentMap FC on fc.Feecode=f.Scheme_Code  where fc.Candidate_Id=C.Candidate_Id and fc.Intake_Id=@IntakeId               
and fd.Feehead_Id not in ( select FeeHeadId from Tbl_Fee_Entry_Main FM where FM.Candidate_Id=C.Candidate_Id and FM.IntakeId=@IntakeId and FM.ItemDescription=fd.ItemDescription)                
                      
                    
union all                     
select FCM.Candidate_Id,FCM.Intake_Id,fcomd.FeeHeadId Feehead_Id,fcomd.Amount,fh2.Fee_Head_Name FeeHeadName,fcomd.CurrencyId Currency,''Compulsory'' typ,fcomd.ItemDescription, fcomd.Amount Balance,''0'' Paid,''0'' pay from Tbl_Fee_Compulsory fcom               


  
 inner join Tbl_Fee_CompulsoryDetails fcomd on fcom.CompulsoryFeeId=fcomd.CumpulsoryFeeId                
 inner join Tbl_Fee_Head fh2 on fh2.Fee_Head_Id=fcomd.FeeHeadId                  
 inner join Tbl_FeecodeStudentMap FCM on FCM.Course_Id=fcom.CourseId where  FCM.Candidate_Id=C.Candidate_Id and FCM.Intake_Id=@IntakeId and  fcom.TypeOfStudent=(select TypeOfStudent from Tbl_Candidate_Personal_Det cp where cp.Candidate_Id=C.Candidate_Id) 
     
             
and fcomd.FeeHeadId not in ( select FM.FeeHeadId from Tbl_Fee_Entry_Main FM where FM.Candidate_Id=C.Candidate_Id and FM.IntakeId=@IntakeId and FM.ItemDescription=fcomd.ItemDescription))T1) as totalbalance            
              
            
 from Tbl_Candidate_Personal_Det C                      
  inner join Tbl_Student_Semester N on N.Candidate_Id=C.Candidate_Id                    
  inner join Tbl_Course_Duration_Mapping cd on cd.Duration_Mapping_Id=N.Duration_Mapping_Id                    
  inner join Tbl_Course_Duration_PeriodDetails dp on dp.Duration_Period_Id=cd.Duration_Period_Id where dp.Batch_Id=@IntakeId                
    and Student_Semester_Current_Status=1 and   Candidate_DelStatus=0              
  union                    
    select distinct(c.Candidate_Id),c.Candidate_Fname+'' ''+ c.Candidate_Mname+'' ''+c.Candidate_Lname CandidateName,                
c.AdharNumber,            
            
(select sum(T1.Amount) as Totaltobepaid from (select Candidate_Id,IntakeId Intake_Id,FeeHeadId Feehead_Id,Amount,           
(select Fee_Head_Name  from dbo.Tbl_Fee_Head where Fee_Head_Id=FM.FeeHeadId)as FeeHeadName ,Currency,typ,ItemDescription,Balance, Paid ,''0'' pay from Tbl_Fee_Entry_Main FM where FM.Candidate_Id=C.Candidate_Id and FM.IntakeId=@IntakeId              
union all              
select fc.Candidate_Id,fc.Intake_Id ,fd.Feehead_Id,fd.Amount,fh1.Fee_Head_Name FeeHeadName,fd.Currency,                
''Normal'' typ,fd.ItemDescription,fd.Amount Balance,                
''0'' Paid,''0'' pay  from TBL_FeeSettingsDetails FD                       
inner join Tbl_Fee_Settings F on f.Fee_Settings_Id=FD.Fee_Settings_Id                
inner join Tbl_Fee_Head fh1 on fh1.Fee_Head_Id=fd.Feehead_Id                       
inner join Tbl_FeecodeStudentMap FC on fc.Feecode=f.Scheme_Code  where fc.Candidate_Id=C.Candidate_Id and fc.Intake_Id=@IntakeId               
and fd.Feehead_Id not in ( select FeeHeadId from Tbl_Fee_Entry_Main FM where FM.Candidate_Id=C.Candidate_Id and FM.IntakeId=@IntakeId and FM.ItemDescription=fd.ItemDescription)           
                      
                    
union all                     
select FCM.Candidate_Id,FCM.Intake_Id,fcomd.FeeHeadId Feehead_Id,fcomd.Amount,fh2.Fee_Head_Name FeeHeadName,fcomd.CurrencyId Currency,''Compulsory'' typ,fcomd.ItemDescription, fcomd.Amount Balance,''0'' Paid,''0'' pay from Tbl_Fee_Compulsory fcom              




 inner join Tbl_Fee_CompulsoryDetails fcomd on fcom.CompulsoryFeeId=fcomd.CumpulsoryFeeId                
 inner join Tbl_Fee_Head fh2 on fh2.Fee_Head_Id=fcomd.FeeHeadId                  
 inner join Tbl_FeecodeStudentMap FCM on FCM.Course_Id=fcom.CourseId where  FCM.Candidate_Id=C.Candidate_Id and FCM.Intake_Id=@IntakeId and  fcom.TypeOfStudent=(select TypeOfStudent from Tbl_Candidate_Personal_Det cp where cp.Candidate_Id=C.Candidate_Id) 

      
             
and fcomd.FeeHeadId not in ( select FM.FeeHeadId from Tbl_Fee_Entry_Main FM where FM.Candidate_Id=C.Candidate_Id and FM.IntakeId=@IntakeId and FM.ItemDescription=fcomd.ItemDescription))T1) as TotalAmountobepaid,            
            
(select sum(T1.Paid) as TotalPaid from (select Candidate_Id,IntakeId Intake_Id,FeeHeadId Feehead_Id,Amount,                   
(select Fee_Head_Name  from dbo.Tbl_Fee_Head where Fee_Head_Id=FM.FeeHeadId)as FeeHeadName ,Currency,typ,ItemDescription,Balance, Paid ,''0'' pay from Tbl_Fee_Entry_Main FM where FM.Candidate_Id=C.Candidate_Id and FM.IntakeId=@IntakeId              
union all              
select fc.Candidate_Id,fc.Intake_Id ,fd.Feehead_Id,fd.Amount,fh1.Fee_Head_Name FeeHeadName,fd.Currency,                
''Normal'' typ,fd.ItemDescription,fd.Amount Balance,                
''0'' Paid,''0'' pay  from TBL_FeeSettingsDetails FD                       
inner join Tbl_Fee_Settings F on f.Fee_Settings_Id=FD.Fee_Settings_Id                
inner join Tbl_Fee_Head fh1 on fh1.Fee_Head_Id=fd.Feehead_Id                       
inner join Tbl_FeecodeStudentMap FC on fc.Feecode=f.Scheme_Code  where fc.Candidate_Id=C.Candidate_Id and fc.Intake_Id=@IntakeId               
and fd.Feehead_Id not in ( select FeeHeadId from Tbl_Fee_Entry_Main FM where FM.Candidate_Id=C.Candidate_Id and FM.IntakeId=@IntakeId and FM.ItemDescription=fd.ItemDescription)                
                      
                    
union all                     
select FCM.Candidate_Id,FCM.Intake_Id,fcomd.FeeHeadId Feehead_Id,fcomd.Amount,fh2.Fee_Head_Name FeeHeadName,fcomd.CurrencyId Currency,''Compulsory'' typ,fcomd.ItemDescription, fcomd.Amount Balance,''0'' Paid,''0'' pay from Tbl_Fee_Compulsory fcom               



 inner join Tbl_Fee_CompulsoryDetails fcomd on fcom.CompulsoryFeeId=fcomd.CumpulsoryFeeId                
 inner join Tbl_Fee_Head fh2 on fh2.Fee_Head_Id=fcomd.FeeHeadId                  
 inner join Tbl_FeecodeStudentMap FCM on FCM.Course_Id=fcom.CourseId where  FCM.Candidate_Id=C.Candidate_Id and FCM.Intake_Id=@IntakeId and  fcom.TypeOfStudent=(select TypeOfStudent from Tbl_Candidate_Personal_Det cp where cp.Candidate_Id=C.Candidate_Id) 

      
             
and fcomd.FeeHeadId not in ( select FM.FeeHeadId from Tbl_Fee_Entry_Main FM where FM.Candidate_Id=C.Candidate_Id and FM.IntakeId=@IntakeId and FM.ItemDescription=fcomd.ItemDescription))T1) as totalpaid,            
            
(select sum(T1.Balance) as Balance from (select Candidate_Id,IntakeId Intake_Id,FeeHeadId Feehead_Id,Amount,                   
(select Fee_Head_Name  from dbo.Tbl_Fee_Head where Fee_Head_Id=FM.FeeHeadId)as FeeHeadName ,Currency,typ,ItemDescription,Balance, Paid ,''0'' pay from Tbl_Fee_Entry_Main FM where FM.Candidate_Id=C.Candidate_Id and FM.IntakeId=@IntakeId              
union all              
select fc.Candidate_Id,fc.Intake_Id ,fd.Feehead_Id,fd.Amount,fh1.Fee_Head_Name FeeHeadName,fd.Currency,                
''Normal'' typ,fd.ItemDescription,fd.Amount Balance,                
''0'' Paid,''0'' pay  from TBL_FeeSettingsDetails FD                       
inner join Tbl_Fee_Settings F on f.Fee_Settings_Id=FD.Fee_Settings_Id                
inner join Tbl_Fee_Head fh1 on fh1.Fee_Head_Id=fd.Feehead_Id                       
inner join Tbl_FeecodeStudentMap FC on fc.Feecode=f.Scheme_Code  where fc.Candidate_Id=C.Candidate_Id and fc.Intake_Id=@IntakeId               
and fd.Feehead_Id not in ( select FeeHeadId from Tbl_Fee_Entry_Main FM where FM.Candidate_Id=C.Candidate_Id and FM.IntakeId=@IntakeId and FM.ItemDescription=fd.ItemDescription)                
                      
                    
union all                     
select FCM.Candidate_Id,FCM.Intake_Id,fcomd.FeeHeadId Feehead_Id,fcomd.Amount,fh2.Fee_Head_Name FeeHeadName,fcomd.CurrencyId Currency,''Compulsory'' typ,fcomd.ItemDescription, fcomd.Amount Balance,''0'' Paid,''0'' pay from Tbl_Fee_Compulsory fcom               



 inner join Tbl_Fee_CompulsoryDetails fcomd on fcom.CompulsoryFeeId=fcomd.CumpulsoryFeeId                
 inner join Tbl_Fee_Head fh2 on fh2.Fee_Head_Id=fcomd.FeeHeadId                  
 inner join Tbl_FeecodeStudentMap FCM on FCM.Course_Id=fcom.CourseId where  FCM.Candidate_Id=C.Candidate_Id and FCM.Intake_Id=@IntakeId and  fcom.TypeOfStudent=(select TypeOfStudent from Tbl_Candidate_Personal_Det cp where cp.Candidate_Id=C.Candidate_Id) 

      
and fcomd.FeeHeadId not in 

( select FM.FeeHeadId from Tbl_Fee_Entry_Main FM where FM.Candidate_Id=C.Candidate_Id and FM.IntakeId=@IntakeId and FM.ItemDescription=fcomd.ItemDescription))T1) as totalbalance            
                     
 from Tbl_Candidate_Personal_Det C                   
 inner join tbl_New_Admission NA on NA.New_Admission_Id=c.New_Admission_Id where NA.Batch_Id=@IntakeId            
and  Candidate_DelStatus=0         
)A 
inner join Tbl_Student_Semester ss on ss.Candidate_Id=A.Candidate_Id
WHERE ss.Student_Semester_Current_Status=1 and A.Candidate_Id IN (SELECT Candidate_Id FROM Tbl_FeecodeStudentMap where  Intake_Id=@IntakeId)order by A.Candidate_Id desc              
              
  end 

    ')
END
