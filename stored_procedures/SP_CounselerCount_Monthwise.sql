IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_CounselerCount_Monthwise]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_CounselerCount_Monthwise]       
 (@CurrentPage bigint=1,                  
@pagesize bigint =10,                  
@Flag Bigint=1,                   
@Datefrom varchar(50)='''' 
 )      
AS      
BEGIN     
if(@Flag=1)                  
begin   
--DECLARE @DateTimeFrom DATETIME = CAST(CONVERT(VARCHAR(10), @Datefrom, 120) + '' 00:00:00.000'' AS DATETIME);
--Select COUNT(*) as Counts, CPD.CounselorEmployee_id,CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                                    
--(convert(date,RegDate,105)) as RegDate  
--FROM Tbl_Lead_Personal_Det  CPD

--inner join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id   
--where (convert(date,RegDate,105)) =@Datefrom  
--group by CPD.CounselorEmployee_id,CONCAT(EC.Employee_FName,'' '',EC.Employee_LName),(convert(date,RegDate,105))  
--Order by CPD.CounselorEmployee_id desc    
     
        
-- OFFSET @PageSize * (@CurrentPage - 1) ROWS        
--    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
--End 
DECLARE @DateTimeFrom DATETIME = CAST(CONVERT(VARCHAR(10), @Datefrom, 120) + '' 00:00:00.000'' AS DATETIME);
Select COUNT(*) as Counts, CPD.Counselor_Employee,CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                                    
(convert(date,Followup_Date,105)) as RegDate  
FROM Tbl_FollowUp_Detail  CPD

inner join Tbl_Employee EC on EC.Employee_Id=CPD.Counselor_Employee   
WHERE CONVERT(DATE, Followup_Date, 105) BETWEEN @DateTimeFrom AND DATEADD(DAY, 30, @DateTimeFrom)  
group by CPD.Counselor_Employee,CONCAT(EC.Employee_FName,'' '',EC.Employee_LName),(convert(date,Followup_Date,105))  
Order by CPD.Counselor_Employee desc    
     
         OFFSET @PageSize * (@CurrentPage - 1) ROWS        
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End
  
if(@Flag=2)                  
begin   
select * into #temp from (       
  
Select COUNT(*) as Counts, CPD.CounselorEmployee_id,CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                                    
(convert(date,RegDate,105)) as RegDate  
FROM Tbl_Lead_Personal_Det  CPD    
inner join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id   
where (convert(date,RegDate,105)) =@Datefrom  
group by CPD.CounselorEmployee_id,CONCAT(EC.Employee_FName,'' '',EC.Employee_LName),(convert(date,RegDate,105))  
  
  )base        
   select count(*) as totcount from #temp     
   End  
END
    ')
END
