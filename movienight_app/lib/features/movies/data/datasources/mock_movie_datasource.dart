import 'package:movienight_app/features/movies/domain/movie.dart';
import 'package:movienight_app/features/movies/domain/movie_filters.dart';

/// Fonte de dados mock com um dataset embutido de filmes populares.
/// Substitui por TmdbDataSource ou OMDbDataSource quando tiveres a API key.
class MockMovieDataSource {
  static const List<Map<String, dynamic>> _rawMovies = [
    {
      'id': 'mock_001',
      'title': 'Inception',
      'overview':
          'A thief who steals corporate secrets through dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.',
      'posterPath': null,
      'releaseYear': 2010,
      'genres': ['Action', 'Sci-Fi', 'Thriller'],
      'rating': 8.8,
      'durationMinutes': 148,
      'streamingPlatforms': ['Netflix', 'HBO Max'],
    },
    {
      'id': 'mock_002',
      'title': 'The Dark Knight',
      'overview':
          'Batman raises the stakes in his war on crime with the help of Lieutenant Jim Gordon and District Attorney Harvey Dent.',
      'posterPath': null,
      'releaseYear': 2008,
      'genres': ['Action', 'Crime', 'Drama'],
      'rating': 9.0,
      'durationMinutes': 152,
      'streamingPlatforms': ['HBO Max'],
    },
    {
      'id': 'mock_003',
      'title': 'Interstellar',
      'overview':
          'A team of explorers travel through a wormhole in space in an attempt to ensure humanity\'s survival.',
      'posterPath': null,
      'releaseYear': 2014,
      'genres': ['Adventure', 'Drama', 'Sci-Fi'],
      'rating': 8.7,
      'durationMinutes': 169,
      'streamingPlatforms': ['Netflix', 'Paramount+'],
    },
    {
      'id': 'mock_004',
      'title': 'The Shawshank Redemption',
      'overview':
          'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.',
      'posterPath': null,
      'releaseYear': 1994,
      'genres': ['Drama'],
      'rating': 9.3,
      'durationMinutes': 142,
      'streamingPlatforms': ['Netflix'],
    },
    {
      'id': 'mock_005',
      'title': 'Pulp Fiction',
      'overview':
          'The lives of two mob hitmen, a boxer, a gangster and his wife intertwine in four tales of violence and redemption.',
      'posterPath': null,
      'releaseYear': 1994,
      'genres': ['Crime', 'Drama', 'Thriller'],
      'rating': 8.9,
      'durationMinutes': 154,
      'streamingPlatforms': ['Netflix', 'Amazon Prime'],
    },
    {
      'id': 'mock_006',
      'title': 'The Matrix',
      'overview':
          'A computer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against its controllers.',
      'posterPath': null,
      'releaseYear': 1999,
      'genres': ['Action', 'Sci-Fi'],
      'rating': 8.7,
      'durationMinutes': 136,
      'streamingPlatforms': ['HBO Max', 'Amazon Prime'],
    },
    {
      'id': 'mock_007',
      'title': 'Parasite',
      'overview':
          'Greed and class discrimination threaten the newly formed symbiotic relationship between the wealthy Park family and the destitute Kim clan.',
      'posterPath': null,
      'releaseYear': 2019,
      'genres': ['Comedy', 'Drama', 'Thriller'],
      'rating': 8.5,
      'durationMinutes': 132,
      'streamingPlatforms': ['HBO Max'],
    },
    {
      'id': 'mock_008',
      'title': 'Spirited Away',
      'overview':
          'During her family\'s move to the suburbs, a sullen 10-year-old girl wanders into a world ruled by gods, witches, and spirits.',
      'posterPath': null,
      'releaseYear': 2001,
      'genres': ['Animation', 'Adventure', 'Family'],
      'rating': 8.6,
      'durationMinutes': 125,
      'streamingPlatforms': ['Netflix'],
    },
    {
      'id': 'mock_009',
      'title': 'Whiplash',
      'overview':
          'A promising young drummer enrolls at a cut-throat music conservatory where his dreams of greatness are challenged by an instructor.',
      'posterPath': null,
      'releaseYear': 2014,
      'genres': ['Drama', 'Music'],
      'rating': 8.5,
      'durationMinutes': 107,
      'streamingPlatforms': ['Netflix', 'Amazon Prime'],
    },
    {
      'id': 'mock_010',
      'title': 'The Grand Budapest Hotel',
      'overview':
          'A writer encounters the owner of an ageing European hotel between the wars and learns of his friendship with the most beloved concierge.',
      'posterPath': null,
      'releaseYear': 2014,
      'genres': ['Adventure', 'Comedy', 'Crime'],
      'rating': 8.1,
      'durationMinutes': 99,
      'streamingPlatforms': ['Disney+', 'Amazon Prime'],
    },
    {
      'id': 'mock_011',
      'title': 'Everything Everywhere All at Once',
      'overview':
          'An aging Chinese immigrant is swept up in an insane adventure, where she alone can save the world by exploring other universes.',
      'posterPath': null,
      'releaseYear': 2022,
      'genres': ['Action', 'Adventure', 'Comedy'],
      'rating': 7.8,
      'durationMinutes': 139,
      'streamingPlatforms': ['Netflix', 'Amazon Prime'],
    },
    {
      'id': 'mock_012',
      'title': 'Get Out',
      'overview':
          'A young African-American visits his white girlfriend\'s parents for the weekend, where his stay becomes disturbing.',
      'posterPath': null,
      'releaseYear': 2017,
      'genres': ['Horror', 'Mystery', 'Thriller'],
      'rating': 7.7,
      'durationMinutes': 104,
      'streamingPlatforms': ['Amazon Prime'],
    },
    {
      'id': 'mock_013',
      'title': 'Dune',
      'overview':
          'A noble family becomes embroiled in a war for control over the galaxy\'s most valuable asset while its scion experiences visions of the future.',
      'posterPath': null,
      'releaseYear': 2021,
      'genres': ['Action', 'Adventure', 'Drama'],
      'rating': 8.0,
      'durationMinutes': 155,
      'streamingPlatforms': ['HBO Max'],
    },
    {
      'id': 'mock_014',
      'title': 'La La Land',
      'overview':
          'While navigating their careers in Los Angeles, a pianist and an actress fall in love while attempting to reconcile their aspirations.',
      'posterPath': null,
      'releaseYear': 2016,
      'genres': ['Comedy', 'Drama', 'Music'],
      'rating': 8.0,
      'durationMinutes': 128,
      'streamingPlatforms': ['Netflix', 'Amazon Prime'],
    },
    {
      'id': 'mock_015',
      'title': 'Mad Max: Fury Road',
      'overview':
          'In a post-apocalyptic wasteland, a woman rebels against a tyrannical ruler in search of her homeland with the aid of a group of female prisoners.',
      'posterPath': null,
      'releaseYear': 2015,
      'genres': ['Action', 'Adventure', 'Sci-Fi'],
      'rating': 8.1,
      'durationMinutes': 120,
      'streamingPlatforms': ['Netflix', 'HBO Max'],
    },
    {
      'id': 'mock_016',
      'title': 'Knives Out',
      'overview':
          'A detective investigates the death of a patriarch of an eccentric, combative family, each member of whom is a suspect.',
      'posterPath': null,
      'releaseYear': 2019,
      'genres': ['Comedy', 'Crime', 'Drama'],
      'rating': 7.9,
      'durationMinutes': 130,
      'streamingPlatforms': ['Amazon Prime'],
    },
    {
      'id': 'mock_017',
      'title': 'Spider-Man: Into the Spider-Verse',
      'overview':
          'Teen Miles Morales becomes the Spider-Man of his universe, and must join with five spider-powered individuals from other dimensions.',
      'posterPath': null,
      'releaseYear': 2018,
      'genres': ['Animation', 'Action', 'Adventure'],
      'rating': 8.4,
      'durationMinutes': 117,
      'streamingPlatforms': ['Netflix', 'Disney+'],
    },
    {
      'id': 'mock_018',
      'title': 'Arrival',
      'overview':
          'A linguist works with the military to communicate with alien lifeforms after twelve mysterious spacecraft appear around the world.',
      'posterPath': null,
      'releaseYear': 2016,
      'genres': ['Drama', 'Mystery', 'Sci-Fi'],
      'rating': 7.9,
      'durationMinutes': 116,
      'streamingPlatforms': ['Netflix', 'Paramount+'],
    },
    {
      'id': 'mock_019',
      'title': 'The Silence of the Lambs',
      'overview':
          'A young F.B.I. cadet must receive the help of an incarcerated and manipulative cannibal killer to help catch another serial killer.',
      'posterPath': null,
      'releaseYear': 1991,
      'genres': ['Crime', 'Drama', 'Thriller'],
      'rating': 8.6,
      'durationMinutes': 118,
      'streamingPlatforms': ['Amazon Prime'],
    },
    {
      'id': 'mock_020',
      'title': 'Oppenheimer',
      'overview':
          'The story of American scientist J. Robert Oppenheimer and his role in the development of the atomic bomb during World War II.',
      'posterPath': null,
      'releaseYear': 2023,
      'genres': ['Biography', 'Drama', 'History'],
      'rating': 8.9,
      'durationMinutes': 180,
      'streamingPlatforms': ['Netflix'],
    },
    {
      'id': 'mock_021',
      'title': 'Barbie',
      'overview':
          'Barbie suffers a crisis that leads her to question her world and her existence after being expelled from Barbieland.',
      'posterPath': null,
      'releaseYear': 2023,
      'genres': ['Adventure', 'Comedy', 'Fantasy'],
      'rating': 7.0,
      'durationMinutes': 114,
      'streamingPlatforms': ['HBO Max'],
    },
    {
      'id': 'mock_022',
      'title': 'Hereditary',
      'overview':
          'A grieving family is haunted by tragic and disturbing occurrences after the loss of their secretive grandmother.',
      'posterPath': null,
      'releaseYear': 2018,
      'genres': ['Drama', 'Horror', 'Mystery'],
      'rating': 7.3,
      'durationMinutes': 127,
      'streamingPlatforms': ['Amazon Prime'],
    },
    {
      'id': 'mock_023',
      'title': 'Coco',
      'overview':
          'Aspiring musician Miguel, confronted with his family\'s ancestral ban on music, enters the Land of the Dead to find his great-great-grandfather.',
      'posterPath': null,
      'releaseYear': 2017,
      'genres': ['Animation', 'Adventure', 'Comedy'],
      'rating': 8.4,
      'durationMinutes': 105,
      'streamingPlatforms': ['Disney+'],
    },
    {
      'id': 'mock_024',
      'title': 'John Wick',
      'overview':
          'An ex-hitman comes out of retirement to track down the gangsters who killed his dog and stole his car.',
      'posterPath': null,
      'releaseYear': 2014,
      'genres': ['Action', 'Crime', 'Thriller'],
      'rating': 7.4,
      'durationMinutes': 101,
      'streamingPlatforms': ['Netflix', 'Amazon Prime'],
    },
    {
      'id': 'mock_025',
      'title': 'The Revenant',
      'overview':
          'A frontiersman on a fur trading expedition in the 1820s fights for survival after being mauled by a bear.',
      'posterPath': null,
      'releaseYear': 2015,
      'genres': ['Action', 'Adventure', 'Drama'],
      'rating': 8.0,
      'durationMinutes': 156,
      'streamingPlatforms': ['Disney+'],
    },
    {
      'id': 'mock_026',
      'title': 'Midsommar',
      'overview':
          'A couple travels to Northern Europe to visit a rural hometown\'s fabled Swedish mid-summer festival, but what begins as an idyllic retreat is revealed to be a sinister pagan cult.',
      'posterPath': null,
      'releaseYear': 2019,
      'genres': ['Drama', 'Horror', 'Mystery'],
      'rating': 7.1,
      'durationMinutes': 148,
      'streamingPlatforms': ['Amazon Prime'],
    },
    {
      'id': 'mock_027',
      'title': 'Soul',
      'overview':
          'After landing the gig of his life, a New York jazz musician suddenly finds himself trapped in a fantastic place between Earth and the afterlife.',
      'posterPath': null,
      'releaseYear': 2020,
      'genres': ['Animation', 'Adventure', 'Comedy'],
      'rating': 8.1,
      'durationMinutes': 100,
      'streamingPlatforms': ['Disney+'],
    },
    {
      'id': 'mock_028',
      'title': 'No Country for Old Men',
      'overview':
          'Violence and mayhem ensue after a hunter stumbles upon a drug deal gone wrong and finds two million dollars in the desert.',
      'posterPath': null,
      'releaseYear': 2007,
      'genres': ['Crime', 'Drama', 'Thriller'],
      'rating': 8.2,
      'durationMinutes': 122,
      'streamingPlatforms': ['Netflix'],
    },
    {
      'id': 'mock_029',
      'title': 'Past Lives',
      'overview':
          'Nora and Hae Sung, two deeply connected childhood friends, are wrest apart after Nora\'s family emigrates from South Korea.',
      'posterPath': null,
      'releaseYear': 2023,
      'genres': ['Drama', 'Romance'],
      'rating': 7.9,
      'durationMinutes': 106,
      'streamingPlatforms': ['Paramount+'],
    },
    {
      'id': 'mock_030',
      'title': 'Alien: Romulus',
      'overview':
          'While scavenging the deep ends of a derelict space station, a group of young space colonizers come face to face with the most terrifying life form in the universe.',
      'posterPath': null,
      'releaseYear': 2024,
      'genres': ['Horror', 'Sci-Fi', 'Thriller'],
      'rating': 7.3,
      'durationMinutes': 119,
      'streamingPlatforms': ['Disney+'],
    },
  ];

  /// Retorna todos os filmes do dataset.
  List<Movie> getAllMovies() {
    return _rawMovies.map(Movie.fromJson).toList();
  }

  /// Filtra o dataset local de acordo com os filtros fornecidos.
  List<Movie> getFilteredMovies(MovieFilters filters) {
    var movies = getAllMovies();

    // Filtrar por género
    if (filters.genres.isNotEmpty) {
      movies = movies
          .where(
            (m) => m.genres.any((g) => filters.genres.contains(g)),
          )
          .toList();
    }

    // Filtrar por ano mínimo
    if (filters.minYear != null) {
      movies = movies
          .where((m) => m.releaseYear >= filters.minYear!)
          .toList();
    }

    // Filtrar por ano máximo
    if (filters.maxYear != null) {
      movies = movies
          .where((m) => m.releaseYear <= filters.maxYear!)
          .toList();
    }

    // Filtrar por duração máxima
    if (filters.maxDurationMinutes != null) {
      movies = movies
          .where(
            (m) =>
                m.durationMinutes == null ||
                m.durationMinutes! <= filters.maxDurationMinutes!,
          )
          .toList();
    }

    // Filtrar por plataforma
    if (filters.streamingPlatforms.isNotEmpty) {
      movies = movies
          .where(
            (m) => m.streamingPlatforms.any(
              (p) => filters.streamingPlatforms.contains(p),
            ),
          )
          .toList();
    }

    // Filtrar por rating mínimo
    if (filters.minRating > 0.0) {
      movies = movies
          .where((m) => m.rating >= filters.minRating)
          .toList();
    }

    // Ordenar por rating decrescente e limitar resultados
    movies.sort((a, b) => b.rating.compareTo(a.rating));

    if (movies.length > filters.maxResults) {
      movies = movies.sublist(0, filters.maxResults);
    }

    return movies;
  }

  /// Géneros únicos disponíveis no dataset.
  List<String> getAvailableGenres() {
    final genres = <String>{};
    for (final movie in getAllMovies()) {
      genres.addAll(movie.genres);
    }
    final sorted = genres.toList()..sort();
    return sorted;
  }

  /// Plataformas únicas disponíveis no dataset.
  List<String> getAvailableStreamingPlatforms() {
    final platforms = <String>{};
    for (final movie in getAllMovies()) {
      platforms.addAll(movie.streamingPlatforms);
    }
    final sorted = platforms.toList()..sort();
    return sorted;
  }
}
