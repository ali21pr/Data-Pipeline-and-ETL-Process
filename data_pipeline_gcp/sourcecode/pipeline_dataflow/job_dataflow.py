import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions

class MyOptions(PipelineOptions):
  @classmethod
  def _add_argparse_args(cls, parser):
    parser.add_value_provider_argument(
      '--inputFile',
      default='/input/icc-rankings.csv',  # Mettez à jour ce chemin
      help='Path of the file to read from')
    parser.add_value_provider_argument(
      '--outputFile',
      default='cd sourcecode/input',  # Mettez à jour ce chemin
      help='Path of the file to write to')

pipeline_options = PipelineOptions([
    '--runner=DirectRunner',
    '--requirements_file=requirements.txt',
    '--save_main_session'
])

def transform(line):
    values = line.split(',')
    obj = {
        'rank': values[0],
        'name': values[1],
        'country': values[2],
        'rating': values[3],
        'points': values[4],
        'lastUpdateOn': values[5],
        'trend': values[6]
    }
    return obj

with beam.Pipeline(options=pipeline_options) as p:
    (p | 'ReadFromLocalFile' >> beam.io.ReadFromText(pipeline_options.get_all_options().get('inputFile'))
       | 'Transform' >> beam.Map(transform)
       | 'WriteToLocalFile' >> beam.io.WriteToText(pipeline_options.get_all_options().get('outputFile'))
    )

