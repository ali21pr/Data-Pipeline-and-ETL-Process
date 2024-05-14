import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions
from datetime import datetime

class MyOptions(PipelineOptions):
  @classmethod
  def _add_argparse_args(cls, parser):
    parser.add_value_provider_argument('--inputFile', type=str, help='Path of the file to read from')
    parser.add_value_provider_argument('--outputTable', type=str, help='Path of the file to write to')

pipeline_options = PipelineOptions([
    '--runner=DataflowRunner',
    '--project=gcpdatapipeline-420609',
    '--staging_location=gs://gcpdatapipeline-420609-gcs-ew1-bucket_dataflow/staging',
    '--temp_location=gs://gcpdatapipeline-420609-gcs-ew1-bucket_dataflow/temp',
    '--template_location=gs://gcpdatapipeline-420609-gcs-ew1-bucket_dataflow/templates/batch_template',
    '--requirements_file=requirements.txt',
    '--save_main_session'
])

def transform(line):
    values = line.split(',')
    obj = {
        'rank': int(values[0]),
        'name': values[1],
        'country': values[2],
        'rating': int(values[3]),
        'points': int(values[4]),
        'lastUpdatedOn': datetime.strptime(values[5], '%Y-%m-%d').date(),
        'trend': values[6]
    }
    return obj

with beam.Pipeline(options=pipeline_options) as p:
    my_options = pipeline_options.view_as(MyOptions)
    (p | 'ReadFromGCS' >> beam.io.ReadFromText(my_options.inputFile)
       | 'Transform' >> beam.Map(transform)
       | 'WriteToBigQuery' >> beam.io.WriteToBigQuery(
           my_options.outputTable,
           schema='rank:INTEGER,name:STRING,country:STRING,rating:INTEGER,points:INTEGER,lastUpdatedOn:DATE,trend:STRING',
           create_disposition=beam.io.BigQueryDisposition.CREATE_IF_NEEDED,
           write_disposition=beam.io.BigQueryDisposition.WRITE_APPEND
       )
    )



