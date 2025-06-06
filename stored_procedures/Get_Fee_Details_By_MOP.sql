IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_Fee_Details_By_MOP]') 
    AND type = N'P'
)
BEGIN
    EXEC('
         
 CREATE procedure [dbo].[Get_Fee_Details_By_MOP]    
 @Department_Id bigint,  
 @Duration_Mapping_Id BIGINT,  
 @MOP VARCHAR(50)  
   
   
 AS    
 BEGIN        
         
                                       
 select A.CandidateName,A.AdharNumber,A.Date,A.Fee_Head_Name,A.Batch,A.MOP,                                 
A.Feeid,A.Remarks,                
A.TagDescription,A.Itemdesc,A.Amounttobepaid,A.AmountPaid,A. Balance,A.ReceiptNo,A.Duration_Mapping_Id,        
A.Course_Code, A.Department_Name,A.Department_Id,A.BatchSemester,A.fedate                                                                     
 from (                        
 select distinct                                         
cpd.Candidate_Fname+'' ''+cpd.Candidate_Mname+'' ''+cpd.Candidate_Lname As CandidateName,                                      
cpd.AdharNumber ,convert(varchar(50),fe.Date,103) as Date,fh.Fee_Head_Name,                                      
 D.Course_Code,                                    
D.Course_Code+''-''+cbd.Batch_Code as Batch ,D.Department_Name,D.Department_Id,    
CBD.Batch_Code+''-''+ CS.Semester_Code as BatchSemester,                          
                                      
             
fe.MOP,fe.Feeid,fe.Remarks ,fe.ReceiptNo,CDM.Duration_Mapping_Id,               
--,pd.Temporary_ReceiptNo                
fe.TagDescription,fe.Itemdesc,fe.Amount as Amounttobepaid,sum(fe.Paid) as AmountPaid,    
fe.Amount-sum(fe.Paid) as  Balance,convert(varchar(50),fe.Date,103) as fedate                                  
    
from dbo.Tbl_Fee_Entry  fe                                        
--inner join dbo.Tbl_Fee_Entry_Details  fed on fed.Fee_Entry_Details_Id=fe.Feeid                                         
inner join  dbo.Tbl_Candidate_Personal_Det  cpd on  cpd.Candidate_Id=fe.Candidate_Id                                         
inner join dbo.Tbl_Fee_Head  fh on fh.Fee_Head_Id=fe.FeeHeadId                                         
inner join dbo.Tbl_Student_Registration SR on SR.Candidate_Id=fe.Candidate_Id                                         
inner join  Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=fe.IntakeId                                        
inner join dbo.Tbl_Department as d on d.Department_Id =SR.Department_Id       
INNER JOIN dbo.Tbl_Course_Duration_PeriodDetails CDP ON CDP.Batch_Id=CBD.Batch_Id    
    
INNER JOIN dbo.Tbl_Course_Duration_Mapping CDM ON CDM.Duration_Period_Id=CDP.Duration_Period_Id            
    
INNER JOIN dbo.Tbl_Course_Semester CS ON CS.Semester_Id=CDP.Semester_Id            
                                      
                                               
where   fe.Paid<>0  
and D.Department_Id=@Department_Id and  
 CDM.Duration_Mapping_Id=@Duration_Mapping_Id and  
 fe.MOP=@MOP  
--and fe.TagDescription is null or fe.TagDescription=''Transfer In''            
group by cpd.Candidate_Fname+'' ''+cpd.Candidate_Mname+'' ''+cpd.Candidate_Lname,                                        
 cpd.AdharNumber ,convert(varchar(50),fe.Date,103),fh.Fee_Head_Name,D.Course_Code+''-''+cbd.Batch_Code,fe.MOP ,    
 fe.Feeid,fe.TagDescription,fe.Remarks,fe.ReceiptNo,Amount,Itemdesc , D.Department_Name,D.Department_Id                          
,D.Course_Code,CBD.Batch_Code,CS.Semester_Code,Duration_Mapping_Id  
  
                
union        
    
                                     
select                                           
cpd.Candidate_Fname+'' ''+cpd.Candidate_Mname+'' ''+cpd.Candidate_Lname As CandidateName,                                        
 cpd.AdharNumber ,convert(varchar(50),fe.Date,103)as Date,fh.Fee_Head_Name,                        
D.Course_Code,                                    
                                                  
D.Course_Code+''-''+cbd.Batch_Code as Batch , D.Department_Name,D.Department_Id,    
CBD.Batch_Code+''-''+ CS.Semester_Code as BatchSemester,                                    
        
fe.MOP,fe.Feeid,fe.Remarks  ,fe.ReceiptNo,CDM.Duration_Mapping_Id                         
,fe.TagDescription,fe.Itemdesc,fe.Amount as Amounttobepaid,sum(fe.Paid) as AmountPaid,    
fe.Amount-sum(fe.Paid) as  Balance ,convert(varchar(50),fe.Date,103) as fedate                                     
                                        
                                        
from dbo.Tbl_Fee_Entry  fe                                     
--inner join dbo.Tbl_Fee_Entry_Details  fed on fed.Fee_Entry_Details_Id=fe.Feeid                                         
inner join  dbo.Tbl_Candidate_Personal_Det  cpd on  cpd.Candidate_Id=fe.Candidate_Id                                   
inner join dbo.Tbl_Fee_Head  fh on fh.Fee_Head_Id=fe.FeeHeadId                                         
inner join dbo.tbl_New_Admission NA on NA.New_Admission_Id=cpd.New_Admission_Id                                        
inner join Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id                                        
inner join dbo.Tbl_Department as d on d.Department_Id =NA.Department_Id                                         
INNER JOIN dbo.Tbl_Course_Duration_PeriodDetails CDP ON CDP.Batch_Id=CBD.Batch_Id    
    
INNER JOIN dbo.Tbl_Course_Duration_Mapping CDM ON CDM.Duration_Period_Id=CDP.Duration_Period_Id            
    
INNER JOIN dbo.Tbl_Course_Semester CS ON CS.Semester_Id=CDP.Semester_Id            
                   
    
where fe.Paid<>0--and fe.TagDescription is null or fe.TagDescription=''Transfer In''         
and D.Department_Id=@Department_Id and  
 CDM.Duration_Mapping_Id=@Duration_Mapping_Id and  
 fe.MOP=@MOP                  
group by cpd.Candidate_Fname+'' ''+cpd.Candidate_Mname+'' ''+cpd.Candidate_Lname,                                        
 cpd.AdharNumber ,convert(varchar(50),fe.Date,103),fh.Fee_Head_Name,D.Course_Code+''-''+cbd.Batch_Code,fe.MOP ,    
 fe.Feeid,fe.Remarks,CBD.Batch_Code,CS.Semester_Code ,    
 fe.TagDescription,fe.ReceiptNo,Amount,Itemdesc, D.Department_Name,D.Department_Id,Duration_Mapping_Id                          
,                                                                       
D.Course_Code                         
  )A    
  END 
    ')
END
