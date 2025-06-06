IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[OverAllActivityReport_SUB]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[OverAllActivityReport_SUB]  
AS BEGIN   
create table #tempt (examfees int,tutionfees int,otherfees int)  
create table #tempt2 (GrandGroupCode varchar(max))  
  
  
declare @examfee int  
declare @tutionfee int  
declare @otherfee int  
  
  
delete from dbo.tbl_Overall_Activity_Report2  
  
  
--SELECT @examfee  
  
  
set @examfee=(  
select FEM.BALANCE --,COUNT(FEM.BALANCE) AS TtionFee--,FH.Fee_Head_Name--=''Tuition Fees''--=''Exam Fees'',FE.Fee_Head_Name=''Tuition Fees''  
 FROM dbo.Tbl_Incentive_GrandGroupMap IG  
INNER JOIN dbo.Tbl_Dep_GroupCourse DG ON DG.GroupCourseCodeId=IG.GroupCourseCodeId  
INNER JOIN dbo.Tbl_Department D ON D.Department_Id=DG.Department_Id  
INNER JOIN dbo.Tbl_Fee_Settings FE ON FE.Course_Id=D.Department_Id  
  
  
INNER JOIN dbo.TBL_FeeSettingsDetails FSD ON FSD.Fee_Settings_Id=FE.Fee_Settings_Id  
INNER JOIN dbo.Tbl_Fee_Head FH ON FH.Fee_Head_Id=FSD.Feehead_Id   
inner join dbo.Tbl_Fee_Entry_Main FEM ON FEM.FeeHeadId=FH.Fee_Head_Id WHERE FH.Fee_Head_Name=''Exam Fees'' --AND FH.Fee_Head_Name=''Exam Fees''  
  
GROUP BY IG.GrandGroupCode,fem.BALANCE)--,D.Department_Id,IG.GroupCourseCodeId)  
  
--SELECT @tutionfee  
  
set @tutionfee=(  
  
select FEM.BALANCE AS TutionFee--,COUNT(FEM.BALANCE) AS TtionFee--,FH.Fee_Head_Name--=''Tuition Fees''--=''Exam Fees'',FE.Fee_Head_Name=''Tuition Fees''  
 FROM dbo.Tbl_Incentive_GrandGroupMap IG  
INNER JOIN dbo.Tbl_Dep_GroupCourse DG ON DG.GroupCourseCodeId=IG.GroupCourseCodeId  
INNER JOIN dbo.Tbl_Department D ON D.Department_Id=DG.Department_Id  
INNER JOIN dbo.Tbl_Fee_Settings FE ON FE.Course_Id=D.Department_Id  
  
  
INNER JOIN dbo.TBL_FeeSettingsDetails FSD ON FSD.Fee_Settings_Id=FE.Fee_Settings_Id  
INNER JOIN dbo.Tbl_Fee_Head FH ON FH.Fee_Head_Id=FSD.Feehead_Id   
inner join dbo.Tbl_Fee_Entry_Main FEM ON FEM.FeeHeadId=FH.Fee_Head_Id WHERE FH.Fee_Head_Name=''Tuition Fees'' --AND FH.Fee_Head_Name=''Exam Fees''  
  
GROUP BY IG.GrandGroupCode,fem.BALANCE)--,D.Department_Id,IG.GroupCourseCodeId)  
  
  
set @otherfee=(select FEM.BALANCE AS OthersFee  
 FROM dbo.Tbl_Incentive_GrandGroupMap IG  
INNER JOIN dbo.Tbl_Dep_GroupCourse DG ON DG.GroupCourseCodeId=IG.GroupCourseCodeId  
INNER JOIN dbo.Tbl_Department D ON D.Department_Id=DG.Department_Id  
INNER JOIN dbo.Tbl_Fee_Settings FE ON FE.Course_Id=D.Department_Id  
  
  
INNER JOIN dbo.TBL_FeeSettingsDetails FSD ON FSD.Fee_Settings_Id=FE.Fee_Settings_Id  
INNER JOIN dbo.Tbl_Fee_Head FH ON FH.Fee_Head_Id=FSD.Feehead_Id   
inner join dbo.Tbl_Fee_Entry_Main FEM ON FEM.FeeHeadId=FH.Fee_Head_Id WHERE FH.Fee_Head_Name<>''Tuition Fees'' and FH.Fee_Head_Name<>''Exam Fees''   
GROUP BY IG.GrandGroupCode,fem.BALANCE)--,D.Department_Id,IG.GroupCourseCodeId)  
   
--SELECT @otherfee  
  
--INSERT INTO tbl_Overall_Activity_Report2(examfee,tutionfee,otherfee) values(@examfee,@tutionfee,@otherfee)  
--select * from  tbl_Overall_Activity_Report2  
insert into #tempt (examfees,tutionfees,otherfees)values(@examfee,@tutionfee,@otherfee)  
--select * from #tempt  
  
insert into #tempt2 (GrandGroupCode) select IG.GrandGroupCode  
FROM dbo.Tbl_Incentive_GrandGroupMap IG  
INNER JOIN dbo.Tbl_Dep_GroupCourse DG ON DG.GroupCourseCodeId=IG.GroupCourseCodeId  
INNER JOIN dbo.Tbl_Department D ON D.Department_Id=DG.Department_Id  
INNER JOIN dbo.Tbl_Fee_Settings FE ON FE.Course_Id=D.Department_Id  
  
  
INNER JOIN dbo.TBL_FeeSettingsDetails FSD ON FSD.Fee_Settings_Id=FE.Fee_Settings_Id  
INNER JOIN dbo.Tbl_Fee_Head FH ON FH.Fee_Head_Id=FSD.Feehead_Id   
inner join dbo.Tbl_Fee_Entry_Main FEM ON FEM.FeeHeadId=FH.Fee_Head_Id  
  
--  
  
--select * from #tempt2  
  
  
  
INSERT INTO tbl_Overall_Activity_Report2(examfees,tutionfees,otherfees) select * from #tempt--,select * from #tempt2  
select * from tbl_Overall_Activity_Report2  
end
    ')
END
