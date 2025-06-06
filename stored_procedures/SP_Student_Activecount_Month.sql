IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Student_Activecount_Month]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Student_Activecount_Month]          
 (              
 @Month Datetime,       
 @Year Datetime,          
 @TypeOfStudent varchar(50) ='''' ,        
 @Typeinter varchar(50) ='''' ,      
 @Flag int =1      
 )          
AS          
BEGIN        
 if @Flag=1              
 begin      
   
   select COUNT(DISTINCT Candidate_Id) as PaidLocalCounts,(select COUNT(DISTINCT Candidate_Id) as PaidInternationalCounts from Tbl_Candidate_Personal_Det CPD    
inner join student_transaction ST on ST.studentid =CPD.Candidate_Id  
left join ref_accountcode RA on ST.accountcodeid=RA.id  
where   FeeStatus=''paid''  and    
 MONTH(create_date)=@Month and TypeOfStudent=@Typeinter and RA.sales=1) as PaidInternationalCounts,    
   (select COUNT(*) as LocalCounts    
 from Tbl_Candidate_Personal_Det where active=3 and  MONTH(create_date)=@Month and TypeOfStudent=@TypeOfStudent) as LocalCounts,    
 (select COUNT(*) as InternationalCounts from Tbl_Candidate_Personal_Det where active=3 and         
 MONTH(create_date)=@Month and TypeOfStudent=@Typeinter) as InternationalCounts      
 from Tbl_Candidate_Personal_Det CPD  inner join student_transaction ST on ST.studentid =CPD.Candidate_Id    
 left join ref_accountcode RA on ST.accountcodeid=RA.id  
  where  YEAR(create_date)=@year and TypeOfStudent=@TypeOfStudent  and FeeStatus=''paid''  and RA.sales=1  
  
--select COUNT(*) as LocalCounts,(select COUNT(*)  from Tbl_Candidate_Personal_Det where active=3 and       
-- MONTH(create_date)=@Month and TypeOfStudent=@Typeinter) as InternationalCounts      
-- from Tbl_Candidate_Personal_Det where active=3 and  MONTH(create_date)=@Month and      
-- TypeOfStudent=@TypeOfStudent and YEAR(create_date)=@Year        
    
--  select COUNT(DISTINCT Candidate_Id) as PaidLocalCounts,(select COUNT(DISTINCT Candidate_Id) as PaidInternationalCounts from Tbl_Candidate_Personal_Det CPD    
--inner join student_transaction ST on ST.studentid =CPD.Candidate_Id where   FeeStatus=''paid''  and    
-- MONTH(create_date)=@Month and TypeOfStudent=@Typeinter) as PaidInternationalCounts,    
--   (select COUNT(*) as LocalCounts    
-- from Tbl_Candidate_Personal_Det where active=3 and  MONTH(create_date)=@Month and TypeOfStudent=@TypeOfStudent) as LocalCounts,    
-- (select COUNT(*) as InternationalCounts from Tbl_Candidate_Personal_Det where active=3 and         
-- MONTH(create_date)=@Month and TypeOfStudent=@Typeinter) as InternationalCounts      
-- from Tbl_Candidate_Personal_Det CPD  inner join student_transaction ST on ST.studentid =CPD.Candidate_Id    
--  where  YEAR(create_date)=@year and TypeOfStudent=@TypeOfStudent  and FeeStatus=''paid''    
    
    
 End      
END
    ')
END
