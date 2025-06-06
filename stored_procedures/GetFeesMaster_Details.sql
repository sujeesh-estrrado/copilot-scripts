IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[GetFeesMaster_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('CREATE procedure [dbo].[GetFeesMaster_Details]  
 @CandidateID varchar(100)  
AS  
  
BEGIN  
  
SELECT B.CandidateName,  
B.Candidate_Id,  
SUM(B.Amountobepaid) AS Amounttobepaid,  
B.paid,  
SUM(B.Amountobepaid)-B.paid AS Balance,  
ISNULL(C.balance,0) AS dueamount  
  
  
FROM   
  
  
( SELECT A.Candidate_Id,  
  A.CandidateName,   
  A.AdharNumber,  
  A.Batch_Code,  
  A.Batch_Id,  
  SUM(A.Amountobepaid) AS Amountobepaid,   
  A.Department_Name,  
  A.Department_Id  
,(SELECT ISNULL(SUM(paid),0) AS paid FROM dbo.Tbl_Fee_Entry FE  WHERE FE.CANDidate_Id=A.CANDidate_Id AND FE.IntakeId=A.Batch_Id) AS paid  
,SUM(A.Amountobepaid)- (SELECT ISNULL(SUM(paid),0) AS paid FROM dbo.Tbl_Fee_Entry FE  WHERE FE.CANDidate_Id=A.CANDidate_Id AND FE.IntakeId=A.Batch_Id) AS Balance  FROM (  
  
(  
 SELECT CPD.CANDidate_Id,  
 CPD.CANDidate_Fname+'' ''+CPD.CANDidate_Mname+'' ''+CPD.CANDidate_Lname AS CANDidateName,  
 CPD.AdharNumber,  
 CBD.Batch_Code,  
 SUM(FSD.Amount) AS Amountobepaid,  
 CBD.Batch_Id,  
 D.Department_Name,  
 D.Department_Id  
 --,FSD.Period_In_Days,cONvert(VARCHAR(50),dateadd(dd,FSD.Period_In_Days,CBD.Batch_FROM),103) AS duedate  
 --,SUM(FSD.Amount)-Paid AS balance  
  
 FROM dbo.Tbl_CANDidate_PersONal_Det CPD   
 INNER JOIN dbo.Tbl_Student_RegistratiON SR ON SR.CANDidate_Id=CPD.CANDidate_Id  
 INNER JOIN  dbo.Tbl_Department D ON SR.Department_Id=D.Department_Id  
 INNER JOIN dbo.Tbl_Student_Semester SS ON SS.CANDidate_Id=CPD.CANDidate_Id  
 INNER JOIN dbo.Tbl_Course_DuratiON_Mapping CDM ON CDM.DuratiON_Mapping_Id=SS.DuratiON_Mapping_Id  
 INNER JOIN dbo.Tbl_Course_DuratiON_PeriodDetails CDP ON CDP.DuratiON_Period_Id=CDM.DuratiON_Period_Id  
 INNER JOIN dbo.Tbl_Course_Batch_DuratiON CBD ON CBD.Batch_Id=CDP.Batch_Id  
 --INNER JOIN dbo.Tbl_Course_Semester CS ON CS.Semester_Id=CDP.Semester_Id  
 INNER JOIN dbo.Tbl_FeecodeStudentMap FSMP ON FSMP.CANDidate_Id=CPD.CANDidate_Id  
 INNER JOIN dbo.Tbl_Fee_Settings FS ON FS.Scheme_Code=FSMP.Feecode  
 INNER JOIN dbo.TBL_FeeSettingsDetails FSD ON FSD.Fee_Settings_Id=FS.Fee_Settings_Id  
 left join dbo.Tbl_Fee_Entry_Main FEM ON FEM.CANDidate_Id=CPD.CANDidate_Id AND FEM.typ=''Normal''  
  
 --INNER JOIN dbo.Tbl_Fee_Head fh ON fh.Fee_Head_Id=FEM.FeeHeadId  
  
 GROUP BY CPD.CANDidate_Id,  
 CPD.CANDidate_Fname+'' ''+CPD.CANDidate_Mname+'' ''+CPD.CANDidate_Lname,  
 CPD.AdharNumber,  
 CBD.Batch_Code ,  
 D.Department_Name,  
 CBD.Batch_Id,  
 D.Department_Id  
--,FSD.Period_In_Days,CBD.Batch_FROM  
)  
UNION  
(  
 SELECT CPD.CANDidate_Id,  
 CPD.CANDidate_Fname+'' ''+CPD.CANDidate_Mname+'' ''+CPD.CANDidate_Lname AS CANDidateName,  
 CPD.AdharNumber,  
 CBD.Batch_Code,  
 SUM(FCD.Amount) AS Amountobepaid,CBD.Batch_Id,  
 --FEM.Paid,FCD.FeeHeadId AS Feehead_Id,  
 D.Department_Name,  
 D.Department_Id  
 --,FCD.PeriodInDays,cONvert(VARCHAR(50),dateadd(dd,FCD.PeriodInDays,CBD.Batch_FROM),103) AS duedate  
 --,SUM(FSD.Amount)-Paid AS balance  
  
 FROM dbo.Tbl_CANDidate_PersONal_Det CPD   
 INNER JOIN dbo.Tbl_Student_RegistratiON SR ON SR.CANDidate_Id=CPD.CANDidate_Id  
 INNER JOIN  dbo.Tbl_Department D ON SR.Department_Id=D.Department_Id  
 INNER JOIN dbo.Tbl_Student_Semester SS ON SS.CANDidate_Id=CPD.CANDidate_Id  
 INNER JOIN dbo.Tbl_Course_DuratiON_Mapping CDM ON CDM.DuratiON_Mapping_Id=SS.DuratiON_Mapping_Id  
 INNER JOIN dbo.Tbl_Course_DuratiON_PeriodDetails CDP ON CDP.DuratiON_Period_Id=CDM.DuratiON_Period_Id  
 INNER JOIN dbo.Tbl_Course_Batch_DuratiON CBD ON CBD.Batch_Id=CDP.Batch_Id  
 --INNER JOIN dbo.Tbl_Course_Semester CS ON CS.Semester_Id=CDP.Semester_Id  
 INNER JOIN dbo.Tbl_Fee_Compulsory FC ON FC.CourseId=D.Department_Id AND FC.TypeOfStudent=CPD.TypeOfStudent  
 INNER JOIN dbo.Tbl_Fee_CompulsoryDetails FCD ON FCD.CumpulsoryFeeId=FC.CompulsoryFeeId  
 --INNER JOIN dbo.Tbl_Fee_Entry_Main FEM ON FEM.CANDidate_Id=CPD.CANDidate_Id  
 GROUP BY   
 CPD.CANDidate_Id,  
 CPD.CANDidate_Fname+'' ''+ CPD.CANDidate_Mname +'' ''+ CPD.CANDidate_Lname,  
 CPD.AdharNumber,  
 CBD.Batch_Code,  
 D.Department_Name,  
 CBD.Batch_Id,  
 D.Department_Id  
--,FCD.PeriodInDays,CBD.Batch_FROM  
)  
UNION  
(SELECT DISTINCT CPD.CANDidate_Id, CPD.CANDidate_Fname+'' ''+CPD.CANDidate_Mname+'' ''+CPD.CANDidate_Lname AS CANDidateName,  
CPD.AdharNumber,  
CBD.Batch_Code,  
SUM(FEM.Amount) AS Amountobepaid,  
CBD.Batch_Id,  
--FEM.Paid,FEM.FeeHeadId AS Feehead_Id,  
D.Department_Name,  
D.Department_Id  
--,''0'' AS PeriodInDays,''0'' AS duedate  
--,SUM(FSD.Amount)-Paid AS balance  
  
FROM dbo.Tbl_Fee_Entry_Main FEM INNER JOIN dbo.Tbl_CANDidate_PersONal_Det CPD   
ON FEM.CANDidate_Id=CPD.CANDidate_Id  
  
INNER JOIN dbo.Tbl_Student_RegistratiON SR ON SR.CANDidate_Id=FEM.CANDidate_Id  
INNER JOIN  dbo.Tbl_Department D ON SR.Department_Id=D.Department_Id  
INNER JOIN dbo.Tbl_Student_Semester SS ON SS.CANDidate_Id=FEM.CANDidate_Id  
INNER JOIN dbo.Tbl_Course_DuratiON_Mapping CDM ON CDM.DuratiON_Mapping_Id=SS.DuratiON_Mapping_Id  
INNER JOIN dbo.Tbl_Course_DuratiON_PeriodDetails CDP ON CDP.DuratiON_Period_Id=CDM.DuratiON_Period_Id  
INNER JOIN dbo.Tbl_Course_Batch_DuratiON CBD ON CBD.Batch_Id=CDP.Batch_Id  
WHERE FEM.typ=''MISC''  
GROUP BY CPD.CANDidate_Id,CPD.CANDidate_Fname+'' ''+CPD.CANDidate_Mname+'' ''+CPD.CANDidate_Lname,  
CPD.AdharNumber,CBD.Batch_Code ,FEM.Paid,D.Department_Name,CBD.Batch_Id,D.Department_Id  
))A GROUP BY A.CANDidate_Id,A.CANDidateName,A.AdharNumber,A.Batch_Code,A.Amountobepaid,A.Department_Name,A.Batch_Id,A.Department_Id)B   
  
  
  
left join   
  
  
  
(SELECT SUM(balance) balance,A.CANDidate_Id,A.Batch_Code FROM(SELECT CPD.CANDidate_Id,  
CPD.CANDidate_Fname+'' ''+CPD.CANDidate_Mname+'' ''+CPD.CANDidate_Lname AS CANDidateName,  
CPD.AdharNumber,CBD.Batch_Code,FSD.Amount AS Amountobepaid,FSD.ItemDescriptiON,  
ISNULL(FEM.Paid,0) AS Paid,  
FSD.Feehead_Id,  
FSD.Amount -ISNULL(FEM.Paid,0) AS balance,  
D.Department_Name,FSD.Period_In_Days,cONvert(VARCHAR(50),dateadd(dd,FSD.Period_In_Days,CBD.Batch_FROM),103) AS duedate,D.Department_Id  
  
  
FROM dbo.Tbl_CANDidate_PersONal_Det CPD   
INNER JOIN dbo.Tbl_Student_RegistratiON SR ON SR.CANDidate_Id=CPD.CANDidate_Id  
INNER JOIN dbo.Tbl_Department D ON SR.Department_Id=D.Department_Id  
INNER JOIN dbo.Tbl_FeecodeStudentMap FSMP ON FSMP.CANDidate_Id=CPD.CANDidate_Id  
INNER JOIN dbo.Tbl_Fee_Settings FS ON FS.Scheme_Code=FSMP.Feecode  
INNER JOIN dbo.Tbl_Course_Batch_DuratiON CBD ON CBD.Batch_Id=FSMP.Intake_Id  
INNER JOIN dbo.TBL_FeeSettingsDetails FSD ON FSD.Fee_Settings_Id=FS.Fee_Settings_Id  
left join dbo.Tbl_Fee_Entry_Main FEM ON FEM.CANDidate_Id=CPD.CANDidate_Id AND FEM.ItemDescriptiON=FSD.ItemDescriptiON   
AND FEM.FeeHeadId=FSD.Feehead_Id AND FEM.Amount=FSD.Amount AND FEM.typ=''Normal''  
  
WHERE  cONvert(datetime,dateadd(dd,FSD.Period_In_Days,CBD.Batch_FROM),103)<getdate()  
GROUP BY FSD.Feehead_Id, CPD.CANDidate_Id,CPD.CANDidate_Fname,CPD.CANDidate_Mname,CPD.CANDidate_Lname,CPD.AdharNumber  
,CBD.Batch_Code,FSD.Amount,D.Department_Name,FSD.Period_In_Days,CBD.Batch_FROM,FSD.ItemDescriptiON,FEM.Paid,D.Department_Id  
UNION  
SELECT CPD.CANDidate_Id,CPD.CANDidate_Fname+'' ''+CPD.CANDidate_Mname+'' ''+CPD.CANDidate_Lname AS CANDidateName,  
CPD.AdharNumber,CBD.Batch_Code,--SUM(FCD.Amount) AS Amountobepaid,  
FCD.Amount AS Amountobepaid,  
FCD.ItemDescriptiON,  
ISNULL(FEM.Paid,0) AS Paid,  
FCD.FeeHeadId,  
FCD.Amount-ISNULL(FEM.Paid,0) AS balance,  
D.Department_Name,  
FCD.PeriodInDays,  
CONVERT(VARCHAR(50),DATEADD(dd,FCD.PeriodInDays,CBD.Batch_FROM),103) AS duedate,D.Department_Id  
  
FROM dbo.Tbl_CANDidate_PersONal_Det CPD   
INNER JOIN dbo.Tbl_Student_RegistratiON SR ON SR.CANDidate_Id=CPD.CANDidate_Id  
INNER JOIN dbo.Tbl_Department D ON SR.Department_Id=D.Department_Id  
INNER JOIN dbo.Tbl_Student_Semester SS ON SS.CANDidate_Id=CPD.CANDidate_Id AND Student_Semester_Current_Status=1  
INNER JOIN dbo.Tbl_Course_DuratiON_Mapping CDM ON CDM.DuratiON_Mapping_Id=SS.DuratiON_Mapping_Id  
INNER JOIN dbo.Tbl_Course_DuratiON_PeriodDetails CDP ON CDP.DuratiON_Period_Id=CDM.DuratiON_Period_Id  
INNER JOIN dbo.Tbl_Course_Batch_DuratiON CBD ON CBD.Batch_Id=CDP.Batch_Id  
INNER JOIN dbo.Tbl_Fee_Compulsory FC ON FC.CourseId=D.Department_Id AND FC.TypeOfStudent=CPD.TypeOfStudent  
INNER JOIN dbo.Tbl_Fee_CompulsoryDetails FCD ON FCD.CumpulsoryFeeId=FC.CompulsoryFeeId  
left join dbo.Tbl_Fee_Entry_Main FEM ON FEM.CANDidate_Id=CPD.CANDidate_Id AND FEM.ItemDescriptiON=FCD.ItemDescriptiON   
AND FEM.FeeHeadId=FCD.FeeHeadId AND FEM.Amount=FCD.Amount AND FEM.typ=''Compulsory''  
  
WHERE cONvert(datetime,dateadd(dd,FCD.PeriodInDays,CBD.Batch_FROM),103)<getdate()  
GROUP BY CPD.CANDidate_Id,CPD.CANDidate_Fname+'' ''+CPD.CANDidate_Mname+'' ''+CPD.CANDidate_Lname,  
CPD.AdharNumber,CBD.Batch_Code,D.Department_Name,CBD.Batch_Id,FCD.PeriodInDays,CBD.Batch_FROM,  
FCD.FeeHeadId,FCD.ItemDescriptiON,FCD.Amount,FEM.Paid,D.Department_Id  
)A GROUP BY A.CANDidate_Id,A.Batch_Code  
)C ON B.CANDidate_Id=C.CANDidate_Id AND B.Batch_Code=C.Batch_Code   
  
WHERE  b.CANDidate_Id=@CandidateID  
GROUP BY B.CANDidateName,  
B.CANDidate_Id,  
B.AdharNumber,  
B.Department_Name,  
B.paid,  
ISNULL(C.balance,0),  
B.Batch_Code,  
C.Batch_Code,  
B.Batch_Id,  
B.Department_Id  
ORDER BY CANDidate_Id    
    
    
END
        
    ')
END
