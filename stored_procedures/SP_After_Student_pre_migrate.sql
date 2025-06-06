IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_After_Student_pre_migrate]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE Procedure [dbo].[SP_After_Student_pre_migrate]
as
begin

--         SET IDENTITY_INSERT tbl_role on;
--update tbl_role set role_Id=1 where role_Id=2;
--SET IDENTITY_INSERT tbl_role off;

Update Tbl_Candidate_Personal_Det set Candidate_Gender=''Female'' where Candidate_Gender=''f'';
 Update Tbl_Candidate_Personal_Det set Candidate_Gender=''Male'' where Candidate_Gender=''m'';

    
    
    update Tbl_Candidate_Personal_Det set Race=''Bumiputra Sarawak'' where Race=''13'';
    update Tbl_Candidate_Personal_Det set Race=''Bumiputra Sabah'' where Race=''12''
    update Tbl_Candidate_Personal_Det set TypeOfStudent=''LOCAL'' where TypeOfStudent=''1''
    update Tbl_Candidate_Personal_Det set TypeOfStudent=''INTERNATIONAL'' where TypeOfStudent=''2''
    update Tbl_Candidate_Personal_Det set Race=''Others'' where Race=''10''
    update Tbl_Candidate_Personal_Det set Race=''Indian'' where Race=''3''
    update Tbl_Candidate_Personal_Det set Race=''Chinese'' where Race=''2''
    update Tbl_Candidate_Personal_Det set Race=''Malay'' where Race=''1''
    update Tbl_Candidate_Personal_Det set Religion=(select Tbl_Religion.Religion from Tbl_Religion where Tbl_Religion.Religion_Id=Tbl_Candidate_Personal_Det.Religion)
  
    UPDATE Tbl_Candidate_Personal_Det
SET Candidate_Nationality = CASE WHEN Candidate_Nationality = 63 THEN 106 
                  WHEN Candidate_Nationality = 106 THEN 63
                  ELSE Candidate_Nationality END
        Update Tbl_Candidate_Personal_Det set Candidate_Fname=LTRIM(RTRIM(Candidate_Fname)),Candidate_Lname=LTRIM(RTRIM(Candidate_Lname))

    update Tbl_Candidate_Personal_Det set Candidate_Fname = (select substring(Candidate_Fname,1,PATINDEX(''% %'',Candidate_Fname))),
                    Candidate_Lname = (select SUBSTRING(Candidate_Fname,patindex(''% %'',Candidate_Fname),LEN(Candidate_Fname))) where patindex(''% %'',Candidate_Fname)>0;
    Update Tbl_Candidate_Personal_Det set Candidate_Fname=LTRIM(RTRIM(Candidate_Fname)),Candidate_Lname=LTRIM(RTRIM(Candidate_Lname))
    


update Tbl_User set role_Id=5 where user_Id in(select user_Id from Tbl_Student_User where Candidate_Id in(select Candidate_Id from Tbl_Candidate_Personal_Det where ApplicationStatus=''Completed''))

update Tbl_Candidate_Personal_Det set Editable=1 
    update Tbl_Candidate_Personal_Det set surname=active
update Tbl_Candidate_Personal_Det set [Status] = ''ACTIVE'',Candidate_Img=(convert(varchar(50),Candidate_Id)+''.jpg''),ApplicationStatus=''pending'' where Candidate_DelStatus =0
update Tbl_Candidate_Personal_Det set Active_Status = ''Active'',ApplicationStatus=''pending'' where Candidate_DelStatus =0
--update Tbl_Candidate_Personal_Det set active=1 ,ApplicationStatus=''pending'' where Active>19 
 UPDATE P
set enrollby=(concat(E.employee_fname,'' '',E.employee_lname))
FROM Tbl_Candidate_Personal_Det P
inner join tbl_employee E on e.employee_id=P.enrollby 
 update Tbl_Candidate_Personal_Det set enrollby=''admin'' where enrollby=''''
 Update Tbl_Candidate_Personal_Det set Candidate_Marital_Status=''Single'' where Candidate_Marital_Status=''1''
Update Tbl_Candidate_Personal_Det set Candidate_Marital_Status=''Married'' where Candidate_Marital_Status=''2''
Update Tbl_Candidate_Personal_Det set Candidate_Marital_Status=''Others'' where Candidate_Marital_Status=''3''
 Update Tbl_Candidate_Personal_Det set SourceofInformation=''Road Show'' where SourceofInformation=''1''
Update Tbl_Candidate_Personal_Det set SourceofInformation=''School Visit'' where SourceofInformation=''2''
Update Tbl_Candidate_Personal_Det set SourceofInformation=''School Fair'' where SourceofInformation=''3''
Update Tbl_Candidate_Personal_Det set SourceofInformation=''Open Day'' where SourceofInformation=''4''
Update Tbl_Candidate_Personal_Det set SourceofInformation=''NS Camp'' where SourceofInformation=''5''
Update Tbl_Candidate_Personal_Det set SourceofInformation=''Education Fair'' where SourceofInformation=''6''
Update Tbl_Candidate_Personal_Det set SourceofInformation=''Walk in'' where SourceofInformation=''7''
Update Tbl_Candidate_Personal_Det set SourceofInformation=''Call in'' where SourceofInformation=''8''
Update Tbl_Candidate_Personal_Det set SourceofInformation=''Post'' where SourceofInformation=''9''
Update Tbl_Candidate_Personal_Det set SourceofInformation=''Online'' where SourceofInformation=''10''
Update Tbl_Candidate_Personal_Det set SourceofInformation=''Fax'' where SourceofInformation=''11''
Update Tbl_Candidate_Personal_Det set SourceofInformation=''Others'' where SourceofInformation=''12''
Update Tbl_Candidate_Personal_Det set SourceofInformation=''Database Import'' where SourceofInformation=''13''
--update Tbl_Candidate_Personal_Det set active=1 where (active=0 or active=9)
    update Tbl_Candidate_Personal_Det set Candidate_DelStatus=1,Active_Status=''Active'',ApplicationStatus=''rejected'',Candidate_Img=(convert(varchar(50),Candidate_Id)+''.jpg'') where active=1 and create_date< DATEADD(year,-5,GETDATE()) and candidate_id>62184;
    update Tbl_Candidate_Personal_Det set Candidate_DelStatus=0,Active_Status=''Active'',ApplicationStatus=''pending'',active=19,Candidate_Img=(convert(varchar(50),Candidate_Id)+''.jpg'') where active=1 and create_date> DATEADD(year,-5,GETDATE()) and candidate_id>62184;

Update Tbl_Candidate_Personal_Det set Feestatus=''paid'' where Candidate_Id in (select  distinct Candidate_Id  from Tbl_Candidate_Personal_Det  s inner join student_transaction t on s.Candidate_Id=t.studentid)
--update Tbl_Candidate_Personal_Det set ApplicationStatus=''Completed'',Candidate_DelStatus=1 where ApplicationStatus is null and (active=15)
--update Tbl_Candidate_Personal_Det set ApplicationStatus=''Completed'',Candidate_DelStatus=1 where ApplicationStatus is null and (active=6 or active=7)
--update Tbl_Candidate_Personal_Det set ApplicationStatus=''Completed'',Candidate_DelStatus=1 where ApplicationStatus is null and (active=5)
--update Tbl_Candidate_Personal_Det set ApplicationStatus=''pending'',Candidate_DelStatus=1 where ApplicationStatus is null and (active=13 or active=14)
--update Tbl_Candidate_Personal_Det set ApplicationStatus=''pending'' where ApplicationStatus is null and active=16
--update Tbl_Candidate_Personal_Det set ApplicationStatus=''Completed'' where ApplicationStatus is null and active=4
--update Tbl_Candidate_Personal_Det set ApplicationStatus=''Completed'' where ApplicationStatus is null and (active=3 or active=8)
--update Tbl_Candidate_Personal_Det set ApplicationStatus=''pending'' where ApplicationStatus is null and active=1
--update Tbl_Candidate_Personal_Det set ApplicationStatus=''pending'' where ApplicationStatus is null and( active=12 or active=10 or active=11 or active=14 or active=17 )
--update Tbl_Candidate_Personal_Det set ApplicationStatus=''Preactivated'' where ApplicationStatus is null and active=18
--update Tbl_Candidate_Personal_Det set ApplicationStatus=''pending'' where ApplicationStatus is null and active=19
update C set C.Candidate_PermAddress_Line2=concat(C.Candidate_PermAddress_Line2,'' '',concat(barracuda_state,'' '',barracuda_city))
from Tbl_Candidate_Personal_Det P
inner join Tbl_Candidate_ContactDetails C on C.Candidate_Id=P.Candidate_Id 
end

    ')
END
