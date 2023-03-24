/*

--cleaning data in SQL queries

*/

select * 
from portfolioproject.dbo.NashvilleHousing


--standardize date format

select saledate, convert(date, saledate)
from portfolioproject.dbo.nashvillehousing


update nashvillehousing 
set saledate= convert(date, saledate)


alter table nashvillehousing
add saledateconverted date 

update nashvillehousing 
set saledateconverted= convert(date, saledate)


select saledateconverted, convert(date, saledate)
from portfolioproject.dbo.nashvillehousing




--populate propertyaddress data
--where propertyaddress is null 

select * from 
portfolioproject.dbo.nashvillehousing where propertyaddress is null


select * from 
portfolioproject.dbo.nashvillehousing order by parcelid


select a.parcelid, a.propertyaddress, b.parcelid,b.propertyaddress from
portfolioproject.dbo.nashvillehousing a join portfolioproject.dbo.nashvillehousing b
on a.parcelid= b.parcelid and a.uniqueid <> b.uniqueid where a.propertyaddress is null


select a.parcelid, a.propertyaddress, b.parcelid,b.propertyaddress,
isnull(a.propertyaddress,b.propertyaddress) from
portfolioproject.dbo.nashvillehousing a join portfolioproject.dbo.nashvillehousing b
on a.parcelid= b.parcelid and a.uniqueid <> b.uniqueid where a.propertyaddress is null


update a set propertyaddress= isnull(a.propertyaddress,b.propertyaddress) from
portfolioproject.dbo.nashvillehousing a join portfolioproject.dbo.nashvillehousing b
on a.parcelid= b.parcelid and a.uniqueid <> b.uniqueid where a.propertyaddress is null


select * from portfolioproject.dbo.nashvillehousing where propertyaddress is null





--dividing propertyaddress into individual columns(address,city,state)

select propertyaddress,substring(propertyaddress,1,charindex(',',propertyaddress)-1) as propertysplitaddress,
substring(propertyaddress,charindex(',',propertyaddress)+1, len(propertyaddress)) as propertysplitcity
from portfolioproject.dbo.nashvillehousing


alter table nashvillehousing add
propertysplitaddress nvarchar(255)

update nashvillehousing  set 
propertysplitaddress =substring(propertyaddress,1,charindex(',',propertyaddress)-1) 


alter table nashvillehousing add
propertysplitcity nvarchar(255)

update nashvillehousing set
propertysplitcity = substring(propertyaddress,charindex(',',propertyaddress)+1, len(propertyaddress))


select * from portfolioproject.dbo.nashvillehousing



select 
owneraddress,parsename(replace(owneraddress,',','.'),3) ,
parsename(replace(owneraddress,',','.'),2),
parsename(replace(owneraddress,',','.'),1)
from portfolioproject.dbo.nashvillehousing

alter table nashvillehousing add
ownersplitaddress nvarchar(255)

update portfolioproject.dbo.nashvillehousing set 
ownersplitaddress=parsename(replace(owneraddress,',','.'),3) 

alter table nashvillehousing add
ownersplitcity nvarchar(255)


update portfolioproject.dbo.nashvillehousing set 
ownersplitcity= parsename(replace(owneraddress,',','.'),2)


alter table nashvillehousing add
ownersplitstate nvarchar(255)

update portfolioproject.dbo.nashvillehousing set 
ownersplitstate = parsename(replace(owneraddress,',','.'),1)



--change y and n to yes and no in soldasvacant column

select distinct(soldasvacant),count(soldasvacant) from
portfolioproject.dbo.nashvillehousing
group by soldasvacant order by 2


select soldasvacant,
case when soldasvacant='Y' THEN 'Yes'
when soldasvacant = 'N' then 'No'
else soldasvacant
end 
from portfolioproject.dbo.nashvillehousing


update nashvillehousing set 
soldasvacant = case when soldasvacant='Y' THEN 'Yes'
when soldasvacant = 'N' then 'No'
else soldasvacant
end 



--deleting duplicates


with rownumCTE as
(select *,
row_number() over(partition by 
                 parcelid,
                 propertyaddress,
			     saledate,
				 saleprice,
				 legalreference order by parcelid) as row_num
from nashvillehousing)
delete from rownumCTE where row_num > 1 




with rownumCTE as
(select *,
row_number() over(partition by 
                 parcelid,
                 propertyaddress,
			     saledate,
				 saleprice,
				 legalreference order by parcelid) as row_num
from nashvillehousing)
select * from rownumCTE where row_num > 1 order by uniqueid


--deleting unused columns

alter table nashvillehousing 
drop column owneraddress,taxdistrict,alteredsaledate,
            propertyaddress1,propertyaddress2,saledate,propertyaddress


select * from portfolioproject.dbo.nashvillehousing


