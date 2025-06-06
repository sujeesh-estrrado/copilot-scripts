IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_FEE_CATEGORY_COLLECTION_REPORT]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_FEE_CATEGORY_COLLECTION_REPORT]  --''2/19/2017'',''9/22/2017''      
(      
 @Fromdate datetime,       
 @Todate datetime      
)      
as begin      
      

if(@FromDate=@ToDate)            
begin            
SELECT       
 D.Department_Name,      
 D.Course_Code,      
 FH.Fee_Head_Name,      
 CONVERT(VARCHAR(50),FE.Date,103),FE.FeeHeadId,      
 SUM(FE.Paid) AS PAID      
      
FROM dbo.Tbl_Student_Registration SR INNER JOIN dbo.Tbl_Department D ON SR.Department_Id=D.Department_Id      
 INNER JOIN dbo.Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id=SR.Candidate_Id      
 INNER JOIN dbo.Tbl_Fee_Entry FE ON FE.Candidate_Id=SR.Candidate_Id      
 INNER JOIN dbo.Tbl_Fee_Head FH ON FH.Fee_Head_Id=FE.FeeHeadId      
 where 
 datepart(mm,fe.Date)=datepart(mm,@FromDate) and                  
 datepart(yyyy,fe.Date)=datepart(yyyy,@FromDate) and datepart(dd,fe.Date)=datepart(dd,@FromDate)                                   
 and datepart(mm,fe.Date)=datepart(mm,@ToDate) and                  
 datepart(yyyy,fe.Date)=datepart(yyyy,@ToDate) and datepart(dd,fe.Date)=datepart(dd,@ToDate)        
and fe.Paid<>0     
 
GROUP BY       
 D.Department_Name,      
 D.Course_Code,      
 FH.Fee_Head_Name,      
 CONVERT(VARCHAR(50),      
 FE.Date,103),      
 FE.FeeHeadId       
 
                 
union                                           
SELECT       
 D.Department_Name,      
 D.Course_Code,      
 FH.Fee_Head_Name,      
 CONVERT(VARCHAR(50),FE.Date,103),FE.FeeHeadId,      
 SUM(FE.Paid) AS PAID      
      
FROM dbo.Tbl_Student_Registration SR INNER JOIN dbo.Tbl_Department D ON SR.Department_Id=D.Department_Id      
 INNER JOIN dbo.Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id=SR.Candidate_Id      
 INNER JOIN dbo.Tbl_Fee_Entry FE ON FE.Candidate_Id=SR.Candidate_Id      
 INNER JOIN dbo.Tbl_Fee_Head FH ON FH.Fee_Head_Id=FE.FeeHeadId                                                   
where         
        
 datepart(mm,fe.Date)=datepart(mm,@FromDate) and                  
 datepart(yyyy,fe.Date)=datepart(yyyy,@FromDate) and datepart(dd,fe.Date)=datepart(dd,@FromDate)                                  
  and datepart(mm,fe.Date)=datepart(mm,@ToDate) and                  
 datepart(yyyy,fe.Date)=datepart(yyyy,@ToDate) and datepart(dd,fe.Date)=datepart(dd,@ToDate)           
and fe.Paid<>0  
         
GROUP BY       
 D.Department_Name,      
 D.Course_Code,      
 FH.Fee_Head_Name,      
 CONVERT(VARCHAR(50),      
 FE.Date,103),      
 FE.FeeHeadId                                           
  
end  
else  
begin  
SELECT       
 D.Department_Name,      
 D.Course_Code,      
 FH.Fee_Head_Name,      
 CONVERT(VARCHAR(50),FE.Date,103),FE.FeeHeadId,      
 SUM(FE.Paid) AS PAID      
      
FROM dbo.Tbl_Student_Registration SR INNER JOIN dbo.Tbl_Department D ON SR.Department_Id=D.Department_Id      
 INNER JOIN dbo.Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id=SR.Candidate_Id      
 INNER JOIN dbo.Tbl_Fee_Entry FE ON FE.Candidate_Id=SR.Candidate_Id      
 INNER JOIN dbo.Tbl_Fee_Head FH ON FH.Fee_Head_Id=FE.FeeHeadId                                                             
where 
fe.Date between @FromDate and @ToDate             
and fe.Paid<>0      
GROUP BY       
 D.Department_Name,      
 D.Course_Code,      
 FH.Fee_Head_Name,      
 CONVERT(VARCHAR(50),      
 FE.Date,103),      
 FE.FeeHeadId      
 
                   
union                                           
 
     
SELECT       
 D.Department_Name,      
 D.Course_Code,      
 FH.Fee_Head_Name,      
 CONVERT(VARCHAR(50),FE.Date,103),FE.FeeHeadId,      
 SUM(FE.Paid) AS PAID      
      
FROM dbo.Tbl_Student_Registration SR INNER JOIN dbo.Tbl_Department D ON SR.Department_Id=D.Department_Id      
 INNER JOIN dbo.Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id=SR.Candidate_Id      
 INNER JOIN dbo.Tbl_Fee_Entry FE ON FE.Candidate_Id=SR.Candidate_Id      
 INNER JOIN dbo.Tbl_Fee_Head FH ON FH.Fee_Head_Id=FE.FeeHeadId                                                  
WHERE datepart(yyyy,fe.Date)=datepart(yyyy,@ToDate) and datepart(dd,fe.Date)=datepart(dd,@ToDate)            
and datepart(mm,fe.Date)=datepart(mm,@ToDate)     
            
and fe.Paid<>0    

GROUP BY       
 D.Department_Name,      
 D.Course_Code,      
 FH.Fee_Head_Name,      
 CONVERT(VARCHAR(50),      
 FE.Date,103),      
 FE.FeeHeadId  

  
end   

end  
    ')
END
