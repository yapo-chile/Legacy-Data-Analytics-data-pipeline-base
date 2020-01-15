# pylint: disable=no-member
# utf-8
import sys
import logging
import pandas as pd
from infraestructure.athena import Athena
from infraestructure.conf import getConf
from infraestructure.psql import Database
from utils.query import Query
from utils.read_params import ReadParams
from utils.time_execution import TimeExecution

def source_data_pulse(params: ReadParams,
                      config: getConf):
    athena = Athena(conf=CONFIG.athenaConf)
    query = Query()
    data_athena = athena.get_data(query.query_base_athena(params))
    athena.close_connection()
    return data_athena

def source_data_dwh(params: ReadParams,
                    config: getConf):
    query = Query()
    db_source = Database(conf=config.db)
    data_dwh = db_source.select_to_dict(query \
                                        .query_base_postgresql(params))
    db_source.close_connection()
    return data_dwh

def destiny_data(params: ReadParams,
                 config: getConf,
                 data_athena: pd.DataFrame,
                 data_dwh: pd.DataFrame) -> None:
    query = Query()
    DB_WRITE = Database(conf=config.db)
    DB_WRITE.execute_command(query.delete_base(params))
    DB_WRITE.insert_data(data_athena)
    DB_WRITE.insert_data(data_dwh)
    DB_WRITE.close_connection()

if __name__ == '__main__':
    CONFIG = getConf()
    TIME = TimeExecution()
    LOGGER = logging.getLogger('data-pipeline-base')
    DATE_FORMAT = """%(asctime)s,%(msecs)d %(levelname)-2s """
    INFO_FORMAT = """[%(filename)s:%(lineno)d] %(message)s"""
    LOG_FORMAT = DATE_FORMAT + INFO_FORMAT
    logging.basicConfig(format=LOG_FORMAT, level=logging.INFO)
    PARAMS = ReadParams(sys.argv)
    DATA_ATHENA = source_data_pulse(PARAMS, CONFIG)
    DATA_DWH = source_data_dwh(PARAMS, CONFIG)
    destiny_data(PARAMS, CONFIG, DATA_ATHENA, DATA_DWH)
    TIME.get_time()
    LOGGER.info('Process ended successfully.')
