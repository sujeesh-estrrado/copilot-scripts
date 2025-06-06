IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_After_migrate]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE Procedure [dbo].[SP_After_migrate]
as
begin
INSERT INTO [dbo].[Tbl_User]
           ([user_Id]
           ,[role_Id]
           ,[user_name]
           ,[user_password]
           ,[user_Status]
           ,[user_DeleteStatus]
           ,[user_Email])
     VALUES
           (1,1,'''','''',1,1,'''');
--         SET IDENTITY_INSERT tbl_role on;
--update tbl_role set role_Id=1 where role_Id=2;
--SET IDENTITY_INSERT tbl_role off;
update Tbl_Course_Duration_PeriodDetails set Semester_Id=1 where Semester_Id=0
update Tbl_Organzations set Organization_DelStatus=(Organization_DelStatus^1);
update Tbl_Student_Semester set Delete_Status=0,Student_Semester_Current_Status=1;
update Tbl_Course_Duration_PeriodDetails set Semester_Id=1 where Semester_Id>10
update Tbl_Course_Duration_PeriodDetails set Duration_Period_Status=0

update Tbl_Course_Level set Course_Level_Status=(Course_Level_Status^1),Delete_Status=(Delete_Status^1);
update Tbl_Course_Category set Course_Category_Status=(Course_Category_Status^1),delete_status=(delete_status^1);
update Tbl_IntakeMaster set DeleteStatus=DeleteStatus^1
 update Tbl_Department set Department_Status=(Department_Status^1),Delete_Status=(Delete_Status^1),Active_Status=''Active'',Org_Id=6;
  update Tbl_Emp_Department set Delete_Status=Dept_Status;
 update Tbl_Emp_Department set Dept_Status=(Dept_Status^1),Delete_Status=(Delete_Status^1);
 update Tbl_Emp_DeptDesignation set Delete_Status=Dept_Designation_Status;
   update Tbl_Emp_DeptDesignation set Delete_Status=0,Dept_Designation_Status=0;
    update Tbl_Emp_DeptDesignation set Dept_Designation_Name=desicription;
    update Tbl_Program_Duration set Delete_Status=0 ,Program_Org_Id=6,Program_Duration_DelStatus=Program_Duration_DelStatus^1;
    update Tbl_Course_Seat_TotalCapacity set Delete_Status=0,Org_Id=6;

    update Tbl_Department_Subjects set Department_Subject_Status=1;
    update Tbl_Semester_Subjects set Semester_Subjects_Status=1;
    update Tbl_Course_Duration_PeriodDetails set Duration_Period_Status=0,Org_Id=6
    update Tbl_Course_Batch_Duration set Batch_DelStatus=Batch_DelStatus^1,Org_Id=6;
    update Tbl_IntakeMaster set DeleteStatus=DeleteStatus^1,Org_Id=6
    update Tbl_Course_Duration_Mapping set Org_Id=6
    update Tbl_Course_Department set Course_Department_Status=Course_Department_Status^1
    
    update Tbl_Candidate_Personal_Det set Candidate_DelStatus=0,Active_Status=''Active'',ApplicationStatus=''Completed'',Candidate_Img=(convert(varchar(50),Candidate_Id)+''.jpg'') where active!=1 and create_date> DATEADD(year,-1,GETDATE());
    update Tbl_Candidate_Personal_Det set Candidate_DelStatus=0,Active_Status=''Active'',ApplicationStatus=''approved'',Candidate_Img=(convert(varchar(50),Candidate_Id)+''.jpg'') where active=1 and create_date> DATEADD(year,-1,GETDATE())
        update Tbl_Candidate_Personal_Det set Candidate_DelStatus=1,Active_Status=''Active'',ApplicationStatus=''approved'',Candidate_Img=(convert(varchar(50),Candidate_Id)+''.jpg''),active=19 where active=1 and create_date< DATEADD(year,-1,GETDATE())
    update Tbl_Candidate_Personal_Det set ApplicationStatus=''Preactivated'' where active=18
    update Tbl_Candidate_Personal_Det set ApplicationStatus=''approved'' where active=2
    update Tbl_Candidate_Personal_Det set ApplicationStatus=''Completed'',active=3 where active=2 and IDMatrixNo!=''''
    update Tbl_IntakeMaster set Org_Id=6, DeleteStatus=DeleteStatus^1
    update Tbl_New_Course set Org_Id=6 , Delete_Status=Delete_Status^1
    update tbl_agent set Delete_Status=0
    update  Tbl_Course_Batch_Duration
set Batch_DelStatus=1
WHERE Batch_Id IN
( SELECT Batch_Id FROM (
 SELECT 
            Batch_Id
            ,ROW_NUMBER() OVER (PARTITION By batch_code ORDER BY Batch_Id) AS [ItemNumber]
            -- Change the partition columns to include the ones that make the row distinct
        FROM 
           Tbl_Course_Batch_Duration 
)a WHERE ItemNumber > 1)
    update student_bill set dateissue=datecreated where  dateissue = ''1900-01-01 00:00:00.000''
    update student_bill set datedue= DATEADD(day, 14, dateissue) where  datedue = ''1900-01-01 00:00:00.000''
    --update Tbl_Candidate_Personal_Det set Candidate_Fname = (select substring(Candidate_Fname,1,PATINDEX(''% %'',Candidate_Fname))),
    --              Candidate_Lname = (select SUBSTRING(Candidate_Fname,patindex(''% %'',Candidate_Fname),LEN(Candidate_Fname)));
    --Update Tbl_Candidate_Personal_Det set Candidate_Fname=LTRIM(RTRIM(Candidate_Fname)),Candidate_Lname=LTRIM(RTRIM(Candidate_Lname))
    update cbd set  cbd.Batch_Code = CONCAT(cbd.Batch_Code,''-'',d.Course_Code) from Tbl_Course_Batch_Duration as cbd join Tbl_Department as d on cbd.Duration_Id=d.Department_Id
    UPDATE Tbl_Agent SET Delete_Status=Agent_Status^1
    UPDATE Tbl_Agent SET Agent_Status=''Active'' where Agent_Status=''1''
UPDATE Tbl_Agent SET Agent_Status=''InActive'' where Agent_Status=''0''
UPDATE Tbl_Agent SET Agent_Status=''InActive'' where Agent_Status=''2''
update Tbl_Agent SET Agent_Country_Id=null where Agent_Category_Id=''''
update Tbl_Agent SET Agent_Mob=null where Agent_Mob=''''
update Tbl_Agent SET Agent_Country_Id=null where Agent_Country_Id=''''
update Tbl_Agent SET Agent_Area=null where Agent_Area=''''
update Tbl_Agent SET Agent_Email=null where Agent_Email=''''
update Tbl_User set role_Id=7 where user_Id in(select user_Id from Tbl_Employee_User where Employee_Id in(select distinct (CounselorEmployee_id) from Tbl_Candidate_Personal_Det))
    Update Tbl_Employee set Employee_FName=LTRIM(RTRIM(Employee_FName)),Employee_LName=LTRIM(RTRIM(Employee_LName))
update Tbl_Employee set Employee_FName = (select substring(Employee_FName,1,PATINDEX(''% %'',Employee_FName))),
                    Employee_LName = (select SUBSTRING(Employee_FName,patindex(''% %'',Employee_FName),LEN(Employee_FName))) where patindex(''% %'', Employee_FName)>0 ;
    Update Tbl_Employee set Employee_FName=LTRIM(RTRIM(Employee_FName)),Employee_LName=LTRIM(RTRIM(Employee_LName))


    update ref_accountcode set deleteStatus=0
update  fee_group set deleteStatus=0
update fee_group set promotional=0 , MinimumAmount=0,MinAdmissionAmountInter=0,MinAdmissionAmountLocal=0
update fee_group set programIntakeID=0 where programIntakeID is null
update ref_accountcode set flagledger =''M'' where flagledger=''m''
update ref_accountcode set flagledger =''S'' where flagledger=''s''
update fee_group_item set deleteStatus = 0
 
 Update Tbl_Agent set Delete_Status=0
 Update Tbl_Agent set Agent_Area=null
 Update Tbl_Agent set Agent_Location=null
 Update Tbl_Agent set Agent_Status=''Active'' where Agent_Status=''1''
  Update Tbl_Agent set Agent_Status=''Inactive'' where Agent_Status=''0''
  Update Tbl_New_Course set Active_Status=''Active'' where Active_Status=''1''
 Update Tbl_New_Course set Active_Status=''InActive'' where    Active_Status=''0''
 update Tbl_Agent_Category set Active_status=''Active'',Commission_Rate=''10''
 update fee_group set dateupdated = datecreated where dateupdated = ''1900-01-01 00:00:00.000''
 Update Tbl_Agent set Agent_Status=''InActive'' where Agent_Status=''2''
 update Tbl_Agent_Category set Delete_Status=0
 update Tbl_Emp_DeptDesignation set Dept_Designation_Status=0
 
-- Update Tbl_Candidate_Personal_Det set SourceofInformation=''Road Show'' where SourceofInformation=''1''
--Update Tbl_Candidate_Personal_Det set SourceofInformation=''School Visit'' where SourceofInformation=''2''
--Update Tbl_Candidate_Personal_Det set SourceofInformation=''School Fair'' where SourceofInformation=''3''
--Update Tbl_Candidate_Personal_Det set SourceofInformation=''Open Day'' where SourceofInformation=''4''
--Update Tbl_Candidate_Personal_Det set SourceofInformation=''NS Camp'' where SourceofInformation=''5''
--Update Tbl_Candidate_Personal_Det set SourceofInformation=''Education Fair'' where SourceofInformation=''6''
--Update Tbl_Candidate_Personal_Det set SourceofInformation=''Walk in'' where SourceofInformation=''7''
--Update Tbl_Candidate_Personal_Det set SourceofInformation=''Call in'' where SourceofInformation=''8''
--Update Tbl_Candidate_Personal_Det set SourceofInformation=''Post'' where SourceofInformation=''9''
--Update Tbl_Candidate_Personal_Det set SourceofInformation=''Online'' where SourceofInformation=''10''
--Update Tbl_Candidate_Personal_Det set SourceofInformation=''Fax'' where SourceofInformation=''11''
--Update Tbl_Candidate_Personal_Det set SourceofInformation=''Others'' where SourceofInformation=''12''
--Update Tbl_Candidate_Personal_Det set SourceofInformation=''Database Import'' where SourceofInformation=''13''
end

    ');
END
