IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_LeadContactDet]')
    AND type = N'P'
)
BEGIN
    EXEC('
  Create procedure [dbo].[SP_Get_LeadContactDet] 
(@Candidate_Id bigint)    
as    
begin    
--select CC.*,CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname
--as candidname,CC.Candidate_PermAddress+'' ''+CC.Candidate_PermAddress_Line2+'' ''+CC.Candidate_PermAddress_postCode
--+'' ''+CS.Country+'' ''+CCS.State_Name+'' ''+CCC.City_Name as Permenent_Address,
--CC.Candidate_ContAddress+'' ''+CC.Candidate_ContAddress_Line2+'' ''+CC.Candidate_ContAddress_postCode+'' ''+CS.Country
--+'' ''+CCS.State_Name+'' ''+CCC.City_Name as Mailing_Address,CPD.EnrollBy,CPD.TypeOfStudent,CPD.Disability_Type,CPD.Mode_Of_Study
  
--from  dbo.Tbl_Candidate_ContactDetails CC
--left join dbo.Tbl_Candidate_Personal_Det CPD  on 
--CPD.Candidate_Id=CC.Candidate_Id left join dbo.Tbl_Country CS on CC.Candidate_ContAddress_Country=CS.Country_Id
--left join dbo.[[Tbl_State]]] CCS  on CCS.State_Id=CC.Candidate_ContAddress_State 
--left join dbo.Tbl_City CCC on CCC.City_Id=CC.Candidate_ContAddress_City where CC.Candidate_Id=@Candidate_Id     
select CC.*, CONCAT(CPD.Candidate_Fname,'' '',CPD.Candidate_Lname)
as candidname,CONCAT(CC.Candidate_PermAddress,''  '',CC.Candidate_PermAddress_Line2,''  '',CC.Candidate_PermAddress_postCode
,''  '',PS.Country,''  '',PCS.State_Name,''  '',PCC.City_Name) as Permenent_Address,CONCAT(employee_fname,'' '',employee_Lname)as counsellorName,
CONCAT(CC.Candidate_ContAddress,''  '',CC.Candidate_ContAddress_Line2,''  '',CC.Candidate_ContAddress_postCode,
''  '',CS.Country
,''  '',CCS.State_Name,''  '',CCC.City_Name) as Mailing_Address,CPD.EnrollBy,
(case when CPD.Disability_Chkbox_Status=''1'' then''Yes'' when CPD.Disability_Chkbox_Status=''0'' then ''No'' when CPD.Disability_Chkbox_Status is null then ''-NA-'' end) as Disability_status  ,CPD.Mode_Of_Study,
(case when CPD.Disability_Chkbox_Status=''1''then CPD.Disability_Type when CPD.Disability_Chkbox_Status=''0'' then ''-NA-'' end ) as Disability_Type,
(case when CPD.BR1M_Status=''1'' then ''Yes'' when CPD.BR1M_Status=0 then ''No'' else ''-NA-''end) as BR1M_Status,
(case when Candidate_Marital_Status!='''' then Candidate_Marital_Status else ''-NA-'' end )as  MaritalStatus,
(case when CPD.TypeOfStudent=''LOCAL'' then ''Local'' when  CPD.TypeOfStudent=''INTERNATIONAL'' then ''International'' else''-NA-'' end) as TypeOfStudent
    from  dbo.Tbl_Lead_ContactDetails CC
        left join dbo.Tbl_Lead_Personal_Det CPD  on CPD.Candidate_Id=CC.Candidate_Id 
        left join dbo.Tbl_Country CS on CC.Candidate_ContAddress_Country=CS.Country_Id
        left join dbo.[[Tbl_State]]] CCS  on CCS.State_Id=CC.Candidate_ContAddress_State 
        left join dbo.Tbl_City CCC on CCC.City_Id=CC.Candidate_ContAddress_City 
        left join dbo.Tbl_Country PS on CC.Candidate_PermAddress_Country=PS.Country_Id
        left join dbo.[[Tbl_State]]] PCS  on PCS.State_Id=CC.Candidate_PermAddress_State 
        left join dbo.Tbl_City PCC on PCC.City_Id=CC.Candidate_PermAddress_City 
        left join Tbl_Employee e on e.Employee_Id=CPD.CounselorEmployee_id    
   where CC.Candidate_Id=@Candidate_Id       
end
    ')
END
