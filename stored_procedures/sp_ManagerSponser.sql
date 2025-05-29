IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_ManagerSponser]') 
    AND type = N'P'
)
BEGIN
    EXEC ('  
    CREATE procedure [dbo].[sp_ManagerSponser] 
    -- [dbo].[sp_ManagerSponser]1,0,''a''
    (@flag int= 0,
    @sponsorid bigint=0,
    @Name varchar(50)='''',
    @contactperson varchar(50)='''',
    @contactnumber varchar(13)='''',
    @cgpa float=0,
    @staffid bigint=0,
    @description varchar(255)='''',
    @address varchar(500)='''',
    @SponcerID varchar(50)='''')
AS
BEGIN


    
    if(@flag=1) ---GetAll_ManagerSponser---
    begin
        Select sponsorname,contactperson,contactnumber,cgpa,staffid,[description],[address] ,sponsorid,SponcerID,*
        from dbo.ref_sponsor
        where ISNULL(Delstatus,0)=0 and (sponsorname like  ''%''+ @Name +''%'' or contactperson like ''%''+ @Name +''%'' 
                or contactnumber like ''%''+ @Name +''%'')
    end
    if(@flag=2) ---Insert_ManagerSponser---
    begin
        Insert into dbo.ref_sponsor (sponsorname,contactperson,contactnumber,cgpa,staffid,[description],[address],SponcerID )
        values (@Name,@contactperson,@contactnumber,@cgpa,@staffid,@description,@address,@SponcerID)
         
    end
    if(@flag=3) ---Update_ManagerSponser---
    begin
        Update dbo.ref_sponsor set sponsorname=@Name,contactperson=@contactperson,contactnumber=@contactnumber,
        cgpa=@cgpa,staffid=@staffid,[description]=@description,[address]=@address,SponcerID=@SponcerID
        where sponsorid=@sponsorid
    end
    if(@flag=4) ---GetById_ManagerSponser---
    begin
        Select sponsorname,contactperson,contactnumber,cgpa,staffid,[description],[address],SponcerID 
        from dbo.ref_sponsor
        Where sponsorid=@sponsorid
    end
    if(@flag=5) ---Del_ManagerSponser---
    begin
        Update dbo.ref_sponsor set DelStatus=1
        Where sponsorid=@sponsorid
    end
    if(@flag=6) ---Dropdown_ManagerSponser---
    begin
        select Concat(Employee_Id_Card_No, ''-'',Employee_FName, '' '' ,Employee_LName) AS Staff,Employee_Id
         from Tbl_Employee
    end
    if(@flag=7) ---GetSponserByName---
    begin
        Select sponsorname,contactperson,contactnumber,cgpa,staffid,[description],[address] ,sponsorid
        from dbo.ref_sponsor
        where Delstatus=0 and sponsorname= (SELECT LTRIM(RTRIM(@Name)) AS TrimmedString) and (@sponsorid !=sponsorid)
    end
    if (@flag=8)
    begin
    Select sponsorname,contactperson,contactnumber,cgpa,staffid,[description],[address] ,sponsorid,SponcerID
    from dbo.ref_sponsor
    where Delstatus=0 and SponcerID= (SELECT LTRIM(RTRIM(@SponcerID)) AS TrimmedString) and (@sponsorid !=sponsorid)
    end

END
    ')
END;
