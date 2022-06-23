#!/bin/bash


echo "Enter the schema name: (default : none)"
read SCHEMA_NAME
SCHEMA_NAME=${SCHEMA_NAME:=}  # Schema
SCHEMA_NAME=${SCHEMA_NAME^^}
if [ "${SCHEMA_NAME}" = "" ]
then
	SCHEMA_NAME=${SCHEMA_NAME}
else
	SCHEMA_NAME+='.'
fi
echo "SCHEMA : ${SCHEMA_NAME}"
echo "Enter the header Y/N: (default : Y) "
read HEADER
HEADER=${HEADER:=Y}     # Header Y/N
HEADER=${HEADER^^}
echo "HEADER : ${HEADER}"

echo "Enter the seperator: (default : | )"
read SEP
SEP=${SEP:=|}        # Seperator
echo "SEPERATOR : ${SEP}"

echo "Enter the table option: (default: NOLOGGING COMPRESS BASIC) "
read OPTION
OPTION=${OPTION:=NOLOGGING COMPRESS BASIC}        # Seperator
echo "TABLE OPTION : ${OPTION}"


echo "Enter the output filename: (default: RESULT_DDL.sql)"
read OUTPUT_FILENAME
OUTPUT_FILENAME=${OUTPUT_FILENAME:=RESULT_DDL.sql}        # Seperator
echo "OUTPUT FILENAME : ${OUTPUT_FILENAME}"
echo "================================================================"
CURRENT_TABLE=''
DDL=''
COMMENT=''
IDX=0
while read line
do
	if [ "${HEADER}" = "Y" ]
	then
		HEADER='N'
		continue
	else
		TABLE_NAME=`echo $line | cut -d ${SEP} -f '1'`
		TABLE_KR=`echo $line | cut -d ${SEP} -f '2'`
		COLUMN_EN=`echo $line | cut -d ${SEP} -f '3'`
		COLUMN_KR=`echo $line | cut -d ${SEP} -f '4'`
		DATA_TYPE=`echo $line | cut -d ${SEP} -f '5'`
		NULLABLE=`echo $line | cut -d ${SEP} -f '6'`
		if [ "${CURRENT_TABLE}" = "${TABLE_NAME}" ]
		then
			DDL+=",${COLUMN_EN} \t ${DATA_TYPE} \t ${NULLABLE} \n"
			COMMENT+="COMMENT ON COLUMN ${SCHEMA_NAME}${TABLE_NAME}.${COLUMN_EN} IS '${COLUMN_KR}';\n"
		else
			if [ ${IDX} -eq 0 ]
			then 
				DDL+="CREATE TABLE ${SCHEMA_NAME}${TABLE_NAME} \n(\n ${COLUMN_EN} \t ${DATA_TYPE} \t ${NULLABLE} \n"
				COMMENT+="\nCOMMENT ON TABLE ${SCHEMA_NAME}${TABLE_NAME} IS '${TABLE_KR}';"
				COMMENT+="\nCOMMENT ON COLUMN ${SCHEMA_NAME}${TABLE_NAME}.${COLUMN_EN} IS '${COLUMN_KR}';\n"
				CURRENT_TABLE=${TABLE_NAME}
				IDX=1
			else 
				DDL+=") NOLOGGING COMPRESS BASIC; \n \nCREATE TABLE ${SCHEMA_NAME}${TABLE_NAME} \n(\n ${COLUMN_EN} \t ${DATA_TYPE} \t ${NULLABLE} \n"
				COMMENT+="\nCOMMENT ON TABLE ${SCHEMA_NAME}${TABLE_NAME} IS '${TABLE_KR}';"
				COMMENT+="\nCOMMENT ON COLUMN ${SCHEMA_NAME}${TABLE_NAME}.${COLUMN_EN} IS '${COLUMN_KR}';\n"
				CURRENT_TABLE=${TABLE_NAME}
			fi
		fi
	fi
done < ./$1
DDL+=") ${OPTION};"
echo -e ${DDL} > ${OUTPUT_FILENAME}
echo -e ${COMMENT} >> ${OUTPUT_FILENAME}
echo "COMPLETE!"
