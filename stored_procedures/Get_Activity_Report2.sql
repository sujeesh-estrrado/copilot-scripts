IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_Activity_Report2]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Get_Activity_Report2]    
    
as    
begin    
    
    
SELECT distinct Tabsub.*,tabother.*,tab.*,tab.GrandGroupCode,tab.ExamFee,tab.FeeHeadId--,TtionFee,OtherFee    
    
from(    
    
    
 select distinct IG.GrandGroupCode,sum(FEM.BALANCE) as ExamFee,FEM.FeeHeadId--,TtionFee,OtherFee  --,COUNT(FEM.BALANCE) AS TtionFee--,FH.Fee_Head_Name--=''Tuition Fees''--=''Exam Fees'',FE.Fee_Head_Name=''Tuition Fees''      
 FROM dbo.Tbl_Incentive_GrandGroupMap IG      
INNER JOIN dbo.Tbl_Dep_GroupCourse DG ON DG.GroupCourseCodeId=IG.GroupCourseCodeId      
INNER JOIN dbo.Tbl_Department D ON D.Department_Id=DG.Department_Id      
INNER JOIN dbo.Tbl_Fee_Settings FE ON FE.Course_Id=D.Department_Id      
      
      
INNER JOIN dbo.TBL_FeeSettingsDetails FSD ON FSD.Fee_Settings_Id=FE.Fee_Settings_Id      
INNER JOIN dbo.Tbl_Fee_Head FH ON FH.Fee_Head_Id=FSD.Feehead_Id       
inner join dbo.Tbl_Fee_Entry_Main FEM ON FEM.FeeHeadId=FH.Fee_Head_Id WHERE FH.Fee_Head_Name=''Exam Fee'' --AND FH.Fee_Head_Name=''Exam Fees''      
    
GROUP BY IG.GrandGroupCode,FEM.FeeHeadId )tab  -- group by tab.GrandGroupCode--,tab.Feehead_Id    
    
inner join     
    
    
(select distinct IG.GrandGroupCode,sum(FEM.BALANCE) AS TutionFee,FEM.FeeHeadId--,TtionFee,OtherFee--,COUNT(FEM.BALANCE) AS TtionFee--,FH.Fee_Head_Name--=''Tuition Fees''--=''Exam Fees'',FE.Fee_Head_Name=''Tuition Fees''      
 FROM dbo.Tbl_Incentive_GrandGroupMap IG      
INNER JOIN dbo.Tbl_Dep_GroupCourse DG ON DG.GroupCourseCodeId=IG.GroupCourseCodeId      
INNER JOIN dbo.Tbl_Department D ON D.Department_Id=DG.Department_Id      
INNER JOIN dbo.Tbl_Fee_Settings FE ON FE.Course_Id=D.Department_Id      
      
      
INNER JOIN dbo.TBL_FeeSettingsDetails FSD ON FSD.Fee_Settings_Id=FE.Fee_Settings_Id      
INNER JOIN dbo.Tbl_Fee_Head FH ON FH.Fee_Head_Id=FSD.Feehead_Id       
inner join dbo.Tbl_Fee_Entry_Main FEM ON FEM.FeeHeadId=FH.Fee_Head_Id WHERE FH.Fee_Head_Name=''Tution Fee'' --AND FH.Fee_Head_Name=''Exam Fees''      
GROUP BY IG.GrandGroupCode,FEM.FeeHeadId)    
    
Tabsub on tab.GrandGroupCode=Tabsub.GrandGroupCode-- group by Tabsub.GrandGroupCode,Tabsub.FeeHeadId    
    
INNER JOIN     
    
    
    
    
(select distinct IG.GrandGroupCode,sum(FEM.BALANCE) AS OtherFee,FEM.FeeHeadId--,TtionFee,OtherFee--,COUNT(FEM.BALANCE) AS TtionFee--,FH.Fee_Head_Name--=''Tuition Fees''--=''Exam Fees'',FE.Fee_Head_Name=''Tuition Fees''      
 FROM dbo.Tbl_Incentive_GrandGroupMap IG      
INNER JOIN dbo.Tbl_Dep_GroupCourse DG ON DG.GroupCourseCodeId=IG.GroupCourseCodeId      
INNER JOIN dbo.Tbl_Department D ON D.Department_Id=DG.Department_Id      
INNER JOIN dbo.Tbl_Fee_Settings FE ON FE.Course_Id=D.Department_Id      
      
      
INNER JOIN dbo.TBL_FeeSettingsDetails FSD ON FSD.Fee_Settings_Id=FE.Fee_Settings_Id      
INNER JOIN dbo.Tbl_Fee_Head FH ON FH.Fee_Head_Id=FSD.Feehead_Id       
inner join dbo.Tbl_Fee_Entry_Main FEM ON FEM.FeeHeadId=FH.Fee_Head_Id WHERE FH.Fee_Head_Name<>''Tution Fee''    
AND FH.Fee_Head_Name<>''Exam Fee''     
GROUP BY IG.GrandGroupCode,FEM.FeeHeadId) tabother on tabother.GrandGroupCode=Tabsub.GrandGroupCode    
    
end

    ')
END
ELSE
BEGIN
EXEC('ALTER procedure [dbo].[Get_Activity_Report2]    
    
as    
begin    
    
    
SELECT distinct Tabsub.*,tabother.*,tab.*,tab.GrandGroupCode,tab.ExamFee,tab.FeeHeadId--,TtionFee,OtherFee    
    
from(    
    
    
 select distinct IG.GrandGroupCode,sum(FEM.BALANCE) as ExamFee,FEM.FeeHeadId--,TtionFee,OtherFee  --,COUNT(FEM.BALANCE) AS TtionFee--,FH.Fee_Head_Name--=''Tuition Fees''--=''Exam Fees'',FE.Fee_Head_Name=''Tuition Fees''      
 FROM dbo.Tbl_Incentive_GrandGroupMap IG      
INNER JOIN dbo.Tbl_Dep_GroupCourse DG ON DG.GroupCourseCodeId=IG.GroupCourseCodeId      
INNER JOIN dbo.Tbl_Department D ON D.Department_Id=DG.Department_Id      
INNER JOIN dbo.Tbl_Fee_Settings FE ON FE.Course_Id=D.Department_Id      
      
      
INNER JOIN dbo.TBL_FeeSettingsDetails FSD ON FSD.Fee_Settings_Id=FE.Fee_Settings_Id      
INNER JOIN dbo.Tbl_Fee_Head FH ON FH.Fee_Head_Id=FSD.Feehead_Id       
inner join dbo.Tbl_Fee_Entry_Main FEM ON FEM.FeeHeadId=FH.Fee_Head_Id WHERE FH.Fee_Head_Name=''Exam Fee'' --AND FH.Fee_Head_Name=''Exam Fees''      
    
GROUP BY IG.GrandGroupCode,FEM.FeeHeadId )tab  -- group by tab.GrandGroupCode--,tab.Feehead_Id    
    
inner join     
    
    
(select distinct IG.GrandGroupCode,sum(FEM.BALANCE) AS TutionFee,FEM.FeeHeadId--,TtionFee,OtherFee--,COUNT(FEM.BALANCE) AS TtionFee--,FH.Fee_Head_Name--=''Tuition Fees''--=''Exam Fees'',FE.Fee_Head_Name=''Tuition Fees''      
 FROM dbo.Tbl_Incentive_GrandGroupMap IG      
INNER JOIN dbo.Tbl_Dep_GroupCourse DG ON DG.GroupCourseCodeId=IG.GroupCourseCodeId      
INNER JOIN dbo.Tbl_Department D ON D.Department_Id=DG.Department_Id      
INNER JOIN dbo.Tbl_Fee_Settings FE ON FE.Course_Id=D.Department_Id      
      
      
INNER JOIN dbo.TBL_FeeSettingsDetails FSD ON FSD.Fee_Settings_Id=FE.Fee_Settings_Id      
INNER JOIN dbo.Tbl_Fee_Head FH ON FH.Fee_Head_Id=FSD.Feehead_Id       
inner join dbo.Tbl_Fee_Entry_Main FEM ON FEM.FeeHeadId=FH.Fee_Head_Id WHERE FH.Fee_Head_Name=''Tution Fee'' --AND FH.Fee_Head_Name=''Exam Fees''      
GROUP BY IG.GrandGroupCode,FEM.FeeHeadId)    
    
Tabsub on tab.GrandGroupCode=Tabsub.GrandGroupCode-- group by Tabsub.GrandGroupCode,Tabsub.FeeHeadId    
    
INNER JOIN     
    
    
    
    
(select distinct IG.GrandGroupCode,sum(FEM.BALANCE) AS OtherFee,FEM.FeeHeadId--,TtionFee,OtherFee--,COUNT(FEM.BALANCE) AS TtionFee--,FH.Fee_Head_Name--=''Tuition Fees''--=''Exam Fees'',FE.Fee_Head_Name=''Tuition Fees''      
 FROM dbo.Tbl_Incentive_GrandGroupMap IG      
INNER JOIN dbo.Tbl_Dep_GroupCourse DG ON DG.GroupCourseCodeId=IG.GroupCourseCodeId      
INNER JOIN dbo.Tbl_Department D ON D.Department_Id=DG.Department_Id      
INNER JOIN dbo.Tbl_Fee_Settings FE ON FE.Course_Id=D.Department_Id      
      
      
INNER JOIN dbo.TBL_FeeSettingsDetails FSD ON FSD.Fee_Settings_Id=FE.Fee_Settings_Id      
INNER JOIN dbo.Tbl_Fee_Head FH ON FH.Fee_Head_Id=FSD.Feehead_Id       
inner join dbo.Tbl_Fee_Entry_Main FEM ON FEM.FeeHeadId=FH.Fee_Head_Id WHERE FH.Fee_Head_Name<>''Tution Fee''    
AND FH.Fee_Head_Name<>''Exam Fee''     
GROUP BY IG.GrandGroupCode,FEM.FeeHeadId) tabother on tabother.GrandGroupCode=Tabsub.GrandGroupCode    
    
end


')
END
